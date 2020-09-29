Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A115D27D1FB
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgI2O5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 10:57:50 -0400
Received: from static-71-183-126-102.nycmny.fios.verizon.net ([71.183.126.102]:35886
        "EHLO chicken.badula.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbgI2O5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 10:57:50 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 10:57:50 EDT
Received: from moisil.badula.org (pool-71-187-225-100.nwrknj.fios.verizon.net [71.187.225.100])
        (authenticated bits=0)
        by chicken.badula.org (8.14.4/8.14.4) with ESMTP id 08TEqnrs027467
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 10:52:49 -0400
To:     stable@vger.kernel.org
From:   Ion Badulescu <ionut@badula.org>
Subject: Network packet reordering with the 5.4 stable tree
Message-ID: <d3066d86-b63a-4a96-0537-e3e40c3826aa@badula.org>
Date:   Tue, 29 Sep 2020 10:52:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on chicken.badula.org
X-Spam-Level: 
X-Spam-Language: en
X-Spam-Status: No, score=0.578 required=5 tests=AWL=0.095,BAYES_00=-1.9,HEXHASH_WORD=1,KHOP_HELO_FCRDNS=0.4,RDNS_DYNAMIC=0.982,SPF_FAIL=0.001
X-Scanned-By: MIMEDefang 2.84
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I ran into some packet reordering using a plain vanilla 5.4.49 kernel 
and the Amazon AWS ena driver. The external symptom was that every now 
and again, one or more larger packets would be delivered to the UDP 
socket after some smaller packets, even though the smaller packets were 
sent after the larger packets. They were also delivered late to a packet 
socket sniffer, which initially made me suspect an RSS bug in the ena 
hardware. Eventually, I modified the ena driver to stamp each packet (by 
overwriting its ethernet source mac field) with the id of the RSS queue 
that delivered it, and with the value of a per-RSS-queue counter that 
incremented for each packet received in that queue. That hack showed RSS 
functioning properly, and also showed packets received earlier (with a 
smaller counter value) being delivered after packets with a larger 
counter value. It established that the reordering was in fact happening 
inside the kernel network core.

The breakthrough came from realizing that the ena driver defaults its 
rx_copybreak to 256, which matched perfectly the boundary between the 
delayed large packets and the smaller packets being delivered first. 
After changing ena's rx_copybreak to zero, the reordering issue disappeared.

After a lot of hair pulling, I think I figured out what the issue is -- 
and it's confined to the 5.4 stable tree. Commit 323ebb61e32b4 (present 
in 5.4) introduced queueing for GRO_NORMAL packets received via 
napi_gro_frags() -> napi_frags_finish(). Commit 6570bc79c0df (NOT 
present in 5.4) extended the same GRO_NORMAL queueing to packets 
received via napi_gro_receive() -> napi_skb_finish(). Without 
6570bc79c0df, packets received via napi_gro_receive() can get delivered 
ahead of the earlier, queued up packets received via napi_gro_frags(). 
And this is precisely what happens in the ena driver with packets 
smaller than rx_copybreak vs packets larger than rx_copybreak.

Interestingly, the 5.4 stable tree does contain a backport of the 
upstream c80794323e commit, which purports to fix issues introduced by 
323ebb61e32b4 and 6570bc79c0df. But 6570bc79c0df itself is missing...

I don't yet have a 5.4-stable patch, since I wanted to first raise the 
issue publicly and confirm I'm not missing something obvious. The patch 
would probably involve massaging 6570bc79c0df quite a bit, to avoid 
colliding with the already-present c80794323e fix.

Thanks,
-Ion

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEFD3B24C0
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 04:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhFXCNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 22:13:00 -0400
Received: from smark.slackware.pl ([88.198.48.135]:49668 "EHLO
        smark.slackware.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFXCM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 22:12:58 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2021 22:12:57 EDT
Received: from [172.22.22.8] (unknown [172.22.22.8])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: shasta@toxcorp.com)
        by smark.slackware.pl (Postfix) with ESMTPSA id 248D3214BC;
        Thu, 24 Jun 2021 04:03:17 +0200 (CEST)
To:     sashal@kernel.org, peterz@infradead.org
Cc:     stable@vger.kernel.org
From:   Jakub Jankowski <shasta@toxcorp.com>
Subject: Backporting 3a7956e25e1d to LTS kernels?
Message-ID: <1c3c181f-514b-f30a-a29a-1f3dd01e2d09@toxcorp.com>
Date:   Thu, 24 Jun 2021 04:03:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

We've recently hit this on 5.4.124:
   WARNING: CPU: 5 PID: 35 at kernel/kthread.c:75 
kthread_is_per_cpu+0x21/0x30

After some digging, I figured out that this should be fixed by commit 
3a7956e25e1d ("kthread: Fix PF_KTHREAD vs to_kthread() race") in mainline.
It Fixes: ac687e6e8c26 ("kthread: Extract KTHREAD_IS_PER_CPU")

3a7956e25e1d has been backported to 5.12.x and 5.11.x:
- 5.12.4:  as 163dd7fa459faebe055bcbebf9e088bae04f8e33
- 5.11.21: as 42e4caa93282ade6a143ff320d71062874dd3a5a

Makes sense, as ac687e6e8c26 originally landed in 5.11.

But it appears that since then ac687e6e8c26 has also been backported to 
LTS trees:
- 5.10.14:  as b20475a80b4bd2c7bc720c3a9a8337c36b20dd8c
- 5.4.96:   as 5b1e4fc2984eab30c5fffbf2bd1f016577cadab6
- 4.19.174: as fbad32181af9c8c76698b16115c28a493c26a2ee
- 4.14.220: as a9b2e4a94eee352e0b3e863045e7379d83131ee2

Maybe those trees could use a backport of 3a7956e25e1d as well then?


Cheers,
  Jakub.

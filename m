Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF84011F204
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 15:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfLNOXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 09:23:48 -0500
Received: from mail1.ugh.no ([178.79.162.34]:46762 "EHLO mail1.ugh.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfLNOXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Dec 2019 09:23:47 -0500
X-Greylist: delayed 586 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Dec 2019 09:23:47 EST
Received: from localhost (localhost [127.0.0.1])
        by mail1.ugh.no (Postfix) with ESMTP id 3659C24E2B6;
        Sat, 14 Dec 2019 15:13:59 +0100 (CET)
Received: from mail1.ugh.no ([127.0.0.1])
        by localhost (catastrophix.ugh.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5pqLAV_NdfjM; Sat, 14 Dec 2019 15:13:58 +0100 (CET)
Received: from [10.255.64.11] (unknown [185.176.245.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: andre@tomt.net)
        by mail.ugh.no (Postfix) with ESMTPSA id 7912724E282;
        Sat, 14 Dec 2019 15:13:58 +0100 (CET)
Subject: Re: [PATCH 4.19 153/306] block: fix the DISCARD request merge
 (4.19.87+ crash)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203126.845809286@linuxfoundation.org>
From:   Andre Tomt <andre@tomt.net>
Message-ID: <aabbc521-b263-2d5f-efc6-72d500ab5c71@tomt.net>
Date:   Sat, 14 Dec 2019 15:13:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191127203126.845809286@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27.11.2019 21:30, Greg Kroah-Hartman wrote:
> From: Jianchao Wang <jianchao.w.wang@oracle.com>
> 
> [ Upstream commit 69840466086d2248898020a08dda52732686c4e6 ]
> 
> There are two cases when handle DISCARD merge.
> If max_discard_segments == 1, the bios/requests need to be contiguous
> to merge. If max_discard_segments > 1, it takes every bio as a range
> and different range needn't to be contiguous.
> 
> But now, attempt_merge screws this up. It always consider contiguity
> for DISCARD for the case max_discard_segments > 1 and cannot merge
> contiguous DISCARD for the case max_discard_segments == 1, because
> rq_attempt_discard_merge always returns false in this case.
> This patch fixes both of the two cases above.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

4.19.87, 4.19.88, 4.19.89 all lock up frequently on some of my systems. 
The same systems run 5.4.3 fine, so the newer trees are probably OK.
Reverting this commit on top of 4.19.87 makes everything stable.

To trigger it all I have to do is re-rsyncing a directory tree with some 
changed files churn, it will usually crash in 10 to 30 minutes.

The systems crashing has ext4 filesystem on a two ssd md raid1 mounted 
with the mount option discard. If mounting it without discard, the 
crashes no longer seem to occur.

No oops/panic made it to the ipmi console. I suspect the console is just 
misbehaving and it didnt really livelock. At one point one line of the 
crash made it to the console (kernel BUG at block/blk-core.c:1776), and 
it was enough to pinpoint this commit. Note that the line number might 
be off, as I was attempting a bisect at the time.

This commit also made it to 4.14.x, but I have not tested it.

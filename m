Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE7B25E673
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 16:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfGCOV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 10:21:56 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:54098 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCOVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 10:21:55 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jul 2019 10:21:54 EDT
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
        by mail.parknet.co.jp (Postfix) with ESMTPSA id 33C231B457B;
        Wed,  3 Jul 2019 23:13:54 +0900 (JST)
Received: from devron.myhome.or.jp (foobar@devron.myhome.or.jp [192.168.0.3])
        by ibmpc.myhome.or.jp (8.15.2/8.15.2/Debian-12) with ESMTPS id x63EDqx6010978
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Wed, 3 Jul 2019 23:13:53 +0900
Received: from devron.myhome.or.jp (foobar@localhost [127.0.0.1])
        by devron.myhome.or.jp (8.15.2/8.15.2/Debian-12) with ESMTPS id x63EDquc026641
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Wed, 3 Jul 2019 23:13:52 +0900
Received: (from hirofumi@localhost)
        by devron.myhome.or.jp (8.15.2/8.15.2/Submit) id x63EDql7026640;
        Wed, 3 Jul 2019 23:13:52 +0900
From:   OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: + fat-add-nobarrier-to-workaround-the-strange-behavior-of-device.patch added to -mm tree
References: <20190702224959.sBsBg%akpm@linux-foundation.org>
        <20190702225053.GA24248@lst.de>
        <20190702160343.0b1fd99491f7b257f68ad82c@linux-foundation.org>
Date:   Wed, 03 Jul 2019 23:13:52 +0900
In-Reply-To: <20190702160343.0b1fd99491f7b257f68ad82c@linux-foundation.org>
        (Andrew Morton's message of "Tue, 2 Jul 2019 16:03:43 -0700")
Message-ID: <87pnmrjjdr.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 3 Jul 2019 00:50:53 +0200 Christoph Hellwig <hch@lst.de> wrote:
>
>> I still very fundamentally disagree with this patch.  We did a concerted
>> effort around the other file systems to move to the device level tweak
>> and remove the badly misnamed option, so we should not add it now for
>> fat.
>
> OK, thanks, I'll leave it on hold for now.

I've checked v5.1, you mentioned "cache_type" (scsi specific
unfortunately). It calls blk_queue_write_cache(), so it calls
wbt_set_write_cache() too. So it affects to writeback throttling.

Is this intended one? At least, it was not what I expected. It is why I
asked side effect of it repeatedly in that thread.

True candidate looks like block layer's "write_cache" introduced after
v4.6. It doesn't call wbt_set_write_cache(). However, I worry if this is
intent or bug, behave like "cache_type". Did this get consensus to
replace "nobarrier" (I hope so)?

If not, I even can't recommend "write_cache", instead of "nobarrier" as
documenting, and we need real replacement to just disable flush command.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

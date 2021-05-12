Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211FB37CB00
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242177AbhELQde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241376AbhELQ1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA6E61DBD;
        Wed, 12 May 2021 15:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834716;
        bh=HH/D9Pn2RaJvhrcPfIpMqvLhEA2rGhnWd1gQMZdlTDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YR2YfFETRK/qBjq3piULC5Bwy2kYkA1epDQtbt0LZmSI5448uHJMVhOi7nqbJswoy
         iA62PiLl2HfL6irOSMqTpquKo115J8Wuep5m4yFR1nAm0U9fh9+C5692XXk0RiIKPG
         h7LWmRX21mZoKI68DSQjEX4Qf7If48sVe0ANZCOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.12 055/677] async_xor: increase src_offs when dropping destination page
Date:   Wed, 12 May 2021 16:41:41 +0200
Message-Id: <20210512144839.041316378@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit ceaf2966ab082bbc4d26516f97b3ca8a676e2af8 upstream.

Now we support sharing one page if PAGE_SIZE is not equal stripe size. To
support this, it needs to support calculating xor value with different
offsets for each r5dev. One offset array is used to record those offsets.

In RMW mode, parity page is used as a source page. It sets
ASYNC_TX_XOR_DROP_DST before calculating xor value in ops_run_prexor5.
So it needs to add src_list and src_offs at the same time. Now it only
needs src_list. So the xor value which is calculated is wrong. It can
cause data corruption problem.

I can reproduce this problem 100% on a POWER8 machine. The steps are:

  mdadm -CR /dev/md0 -l5 -n3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --size=3G
  mkfs.xfs /dev/md0
  mount /dev/md0 /mnt/test
  mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.

Fixes: 29bcff787a25 ("md/raid5: add new xor function to support different page offset")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/async_tx/async_xor.c |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -233,6 +233,7 @@ async_xor_offs(struct page *dest, unsign
 		if (submit->flags & ASYNC_TX_XOR_DROP_DST) {
 			src_cnt--;
 			src_list++;
+			src_offs++;
 		}
 
 		/* wait for any prerequisite operations */



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6EB378946
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbhEJL0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:26:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238275AbhEJLRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD5F6162B;
        Mon, 10 May 2021 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645179;
        bh=B2vH7NJbtLKWWtienQ5S5qC1IhqOMtqm6mR+fPpiayk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ol6dOWtmpldbZMVHpgwTVxxb1gMZjjgeYEpmW7Z3rabOCkaJBDPIdS/1R/FRDk75X
         Dac0BM4tcdtQee+dHQ9mh+RYAPbZQZshcUAE6a3q/se9cVqIN5iZbwQYN598A/i/lw
         M+GAQBo59KmZUICFAHB4y3HaOcc2gpMRFhqm7pxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tian Tao <tiantao6@hisilicon.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.12 378/384] dm integrity: fix missing goto in bitmap_flush_interval error handling
Date:   Mon, 10 May 2021 12:22:47 +0200
Message-Id: <20210510102027.236028374@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

commit 17e9e134a8efabbbf689a0904eee92bb5a868172 upstream.

Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4039,6 +4039,7 @@ static int dm_integrity_ctr(struct dm_ta
 			if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
 				r = -EINVAL;
 				ti->error = "Invalid bitmap_flush_interval argument";
+				goto bad;
 			}
 			ic->bitmap_flush_interval = msecs_to_jiffies(val);
 		} else if (!strncmp(opt_string, "internal_hash:", strlen("internal_hash:"))) {



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD89378712
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhEJLN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235918AbhEJLG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:06:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7947E616EB;
        Mon, 10 May 2021 10:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644221;
        bh=IPKWq9sT5e08ugTSlgBDGvzhnCFNfvWl1pQt54L2Tf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuJxAn1b3k2SlfB8s48cnvLwJP+SbWryEFqEk0u3pelb7wvgr2nug2B+poiEAOV9H
         Jb21u4AMFKx3lG7M8rTaP+Y2XGEXoo788VvgdzPatS4+3s/8bMvfA6g8CV7rFSlKO/
         uOiKeBTwdq9zPfjz4VL/1NLFC8r5kGGxjy5vCCkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tian Tao <tiantao6@hisilicon.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 337/342] dm integrity: fix missing goto in bitmap_flush_interval error handling
Date:   Mon, 10 May 2021 12:22:07 +0200
Message-Id: <20210510102021.243996713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
@@ -3929,6 +3929,7 @@ static int dm_integrity_ctr(struct dm_ta
 			if (val >= (uint64_t)UINT_MAX * 1000 / HZ) {
 				r = -EINVAL;
 				ti->error = "Invalid bitmap_flush_interval argument";
+				goto bad;
 			}
 			ic->bitmap_flush_interval = msecs_to_jiffies(val);
 		} else if (!strncmp(opt_string, "internal_hash:", strlen("internal_hash:"))) {



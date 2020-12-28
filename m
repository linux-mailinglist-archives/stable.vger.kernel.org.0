Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4C82E40CB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440683AbgL1OPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440654AbgL1OPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8621D22B2B;
        Mon, 28 Dec 2020 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164893;
        bh=EwWYf0l3c77LObBRIzTxn4rOwQxgD5rxQ9U3iVNuaQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqI2q/THEqsycNomFW//S+VUHLCuZNYlOmzngxbS5g0XtGrGQDB2Tam2We56j15+h
         OJXDjfg9T7/oQOUWaDApquvLHfzJWgFpxnqRQtMGRinzdoPys7UrJxN5hmazsRB7j7
         anxvyzZAn3z7ZJm7ZnTdC78Ifa1YlZ4Jax4GzM9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Vaibhav Agarwal <vaibhav.sr@gmail.com>,
        Wang Hai <wanghai38@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/717] staging: greybus: audio: Fix possible leak free widgets in gbaudio_dapm_free_controls
Date:   Mon, 28 Dec 2020 13:45:34 +0100
Message-Id: <20201228125037.119719747@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit e77b259f67ab99f1e22ce895b9b1c637fd5f2d4c ]

In gbaudio_dapm_free_controls(), if one of the widgets is not found, an error
will be returned directly, which will cause the rest to be unable to be freed,
resulting in leak.

This patch fixes the bug. If if one of them is not found, just skip and free the others.

Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio module")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Vaibhav Agarwal <vaibhav.sr@gmail.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20201205103827.31244-1-wanghai38@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/audio_helper.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/greybus/audio_helper.c b/drivers/staging/greybus/audio_helper.c
index 237531ba60f30..3011b8abce389 100644
--- a/drivers/staging/greybus/audio_helper.c
+++ b/drivers/staging/greybus/audio_helper.c
@@ -135,7 +135,8 @@ int gbaudio_dapm_free_controls(struct snd_soc_dapm_context *dapm,
 		if (!w) {
 			dev_err(dapm->dev, "%s: widget not found\n",
 				widget->name);
-			return -EINVAL;
+			widget++;
+			continue;
 		}
 		widget++;
 #ifdef CONFIG_DEBUG_FS
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E10627C5FE
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbgI2Lky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730576AbgI2Lkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C545421924;
        Tue, 29 Sep 2020 11:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379631;
        bh=jGhZISFgVL+/FUIGMcXqvuU+A9Nr5jP1pkKvf9EPlPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17FbeLt4z3eaDmNxvB/kDokILaah3TWjvGSH2HgUFR8BD85kvtKYrSeXGkmCrr54D
         98cnHh103FM5IrXlcnKXrYJHdlkKXPLv6KiufzbtZExj9LXrd8pG+7flm9wQ28TIHW
         8WNkZypnPaPnacxAlop9SVxnmDaITwksSZadU/g0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 248/388] media: venus: vdec: Init registered list unconditionally
Date:   Tue, 29 Sep 2020 12:59:39 +0200
Message-Id: <20200929110022.487807492@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit bc3d870e414b42d72cd386aa20a4fc3612e4feb7 ]

Presently the list initialization is done only in
dynamic-resolution-change state, which leads to list corruptions
and use-after-free. Init list_head unconditionally in
vdec_stop_capture called by vb2 stop_streaming without takeing
into account current codec state.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 59ae7a1e63bc2..05b80a66e80ed 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -987,13 +987,14 @@ static int vdec_stop_capture(struct venus_inst *inst)
 		ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
 		vdec_cancel_dst_buffers(inst);
 		inst->codec_state = VENUS_DEC_STATE_CAPTURE_SETUP;
-		INIT_LIST_HEAD(&inst->registeredbufs);
 		venus_helper_free_dpb_bufs(inst);
 		break;
 	default:
-		return 0;
+		break;
 	}
 
+	INIT_LIST_HEAD(&inst->registeredbufs);
+
 	return ret;
 }
 
-- 
2.25.1




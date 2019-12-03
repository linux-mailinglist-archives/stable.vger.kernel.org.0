Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6891C111C18
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfLCWkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbfLCWkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E3E720684;
        Tue,  3 Dec 2019 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412811;
        bh=vUBQZr3skgGhnkUVrXHXn06oQboJ/0dP2cDMO1v6I80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfySwlgzDDI+fX7vWGUWCRhRla8YdezRYPeEX66oYMdCLEJtyFHorRruOSdr3cNlq
         +4moWetOAE2//lo2Saet4lgWan9TsNgBexG62eMal0XNd4JJgHekR4fA2/J2YlVBhs
         Zk/9HQF2gjkchEQOkObmL2rZdAypEUz+heXRFL2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 025/135] ASoC: SOF: ipc: Fix memory leak in sof_set_get_large_ctrl_data
Date:   Tue,  3 Dec 2019 23:34:25 +0100
Message-Id: <20191203213010.441107861@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 45c1380358b12bf2d1db20a5874e9544f56b34ab ]

In the implementation of sof_set_get_large_ctrl_data() there is a memory
leak in case an error. Release partdata if sof_get_ctrl_copy_params()
fails.

Fixes: 54d198d5019d ("ASoC: SOF: Propagate sof_get_ctrl_copy_params() error properly")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20191027215330.12729-1-navid.emamdoost@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/ipc.c b/sound/soc/sof/ipc.c
index 20dfca9c93b76..c4086186722f3 100644
--- a/sound/soc/sof/ipc.c
+++ b/sound/soc/sof/ipc.c
@@ -578,8 +578,10 @@ static int sof_set_get_large_ctrl_data(struct snd_sof_dev *sdev,
 	else
 		err = sof_get_ctrl_copy_params(cdata->type, partdata, cdata,
 					       sparams);
-	if (err < 0)
+	if (err < 0) {
+		kfree(partdata);
 		return err;
+	}
 
 	msg_bytes = sparams->msg_bytes;
 	pl_size = sparams->pl_size;
-- 
2.20.1




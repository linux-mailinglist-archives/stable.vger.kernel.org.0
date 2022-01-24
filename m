Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41144499949
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453916AbiAXVbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450846AbiAXVVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A9BC0604DF;
        Mon, 24 Jan 2022 12:16:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98BCBB8122F;
        Mon, 24 Jan 2022 20:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D5FC340E5;
        Mon, 24 Jan 2022 20:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055371;
        bh=fH45R+ON9VtofQLm2ZUtUvYmVRrVZ/+s/iF2FwrMnWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKmwKeF3fk03AHMY0mVmCxCGwP43Yc9zzahP+9mXKgSLbYiJlgFjFXAm9sHh/hYtS
         NDbADaGlfEk8XPF0RZvKwdaxpp0PpmHNtFEWhTCr17by+HEqkc/GtIx4t6DEnM6ncn
         Vv9chZRyFJPNpeJ+dSTXUh7R9CBZ+ubUkhd2divA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/846] media: atomisp: fix inverted error check for ia_css_mipi_is_source_port_valid()
Date:   Mon, 24 Jan 2022 19:33:49 +0100
Message-Id: <20220124184104.837357983@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit d21ce8c2f7bf6d737b60c09f86db141b9e8e47f0 ]

The function ia_css_mipi_is_source_port_valid() returns true if the port
is valid. So, we can't use the existing err variable as is.

To fix this issue while reusing that variable, invert the return value
when assigning it to the variable.

Fixes: 3c0538fbad9f ("media: atomisp: get rid of most checks for ISP2401 version")
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/sh_css_mipi.c   | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/sh_css_mipi.c b/drivers/staging/media/atomisp/pci/sh_css_mipi.c
index 65fc93c5d56bc..c1f2f6151c5f8 100644
--- a/drivers/staging/media/atomisp/pci/sh_css_mipi.c
+++ b/drivers/staging/media/atomisp/pci/sh_css_mipi.c
@@ -423,10 +423,12 @@ allocate_mipi_frames(struct ia_css_pipe *pipe,
 		return 0; /* AM TODO: Check  */
 	}
 
-	if (!IS_ISP2401)
+	if (!IS_ISP2401) {
 		port = (unsigned int)pipe->stream->config.source.port.port;
-	else
-		err = ia_css_mipi_is_source_port_valid(pipe, &port);
+	} else {
+		/* Returns true if port is valid. So, invert it */
+		err = !ia_css_mipi_is_source_port_valid(pipe, &port);
+	}
 
 	assert(port < N_CSI_PORTS);
 
@@ -553,10 +555,12 @@ free_mipi_frames(struct ia_css_pipe *pipe)
 			return err;
 		}
 
-		if (!IS_ISP2401)
+		if (!IS_ISP2401) {
 			port = (unsigned int)pipe->stream->config.source.port.port;
-		else
-			err = ia_css_mipi_is_source_port_valid(pipe, &port);
+		} else {
+			/* Returns true if port is valid. So, invert it */
+			err = !ia_css_mipi_is_source_port_valid(pipe, &port);
+		}
 
 		assert(port < N_CSI_PORTS);
 
@@ -665,10 +669,12 @@ send_mipi_frames(struct ia_css_pipe *pipe)
 		/* TODO: AM: maybe this should be returning an error. */
 	}
 
-	if (!IS_ISP2401)
+	if (!IS_ISP2401) {
 		port = (unsigned int)pipe->stream->config.source.port.port;
-	else
-		err = ia_css_mipi_is_source_port_valid(pipe, &port);
+	} else {
+		/* Returns true if port is valid. So, invert it */
+		err = !ia_css_mipi_is_source_port_valid(pipe, &port);
+	}
 
 	assert(port < N_CSI_PORTS);
 
-- 
2.34.1




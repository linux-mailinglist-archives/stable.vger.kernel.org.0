Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC60549968D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445777AbiAXVE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444251AbiAXVAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:00:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A09AB61320;
        Mon, 24 Jan 2022 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820B1C340E5;
        Mon, 24 Jan 2022 21:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058030;
        bh=fH45R+ON9VtofQLm2ZUtUvYmVRrVZ/+s/iF2FwrMnWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aM0r7OA3fNQxv+OS44+WIQSfqyRgk7S0h9kqfVFDgGhWnj4GWwGjJPF/Shco50pjF
         cIsf4jPLwQ12gm2Uff/l6rBmkG6XsH7zmJVQzJTZn11/rT0q0BGME2D1PsoBRTZN22
         RPFPRXDKPsr9dACznJiY3t+I8PQFK5eARywtwM1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tsuchiya Yuto <kitakar@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0125/1039] media: atomisp: fix inverted error check for ia_css_mipi_is_source_port_valid()
Date:   Mon, 24 Jan 2022 19:31:54 +0100
Message-Id: <20220124184129.346371798@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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




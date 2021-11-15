Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FC3451EE6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348346AbhKPAhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344659AbhKOTZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EDBE63368;
        Mon, 15 Nov 2021 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002915;
        bh=Hhpt5/09ihCRRLXi62CCzQZ6wDu7vcGPY0lWg+4fKHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWHhzxKGdwdJGlOZEYzSAfvI3xkh6kTRnGh9i0OSxP5imqijJ454BrGItm2OUWCe1
         JTh8GXrE37lRj4pBcBbAyCL34K78Ozch68OlBaNOI09obHgCahqYJV/xqYDrqxCepl
         Ky+svVHEPuZNurC+TmWg2YyAeRqgZEvrnTHSI2Pk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 736/917] soc: fsl: dpaa2-console: free buffer before returning from dpaa2_console_read
Date:   Mon, 15 Nov 2021 18:03:51 +0100
Message-Id: <20211115165453.870074619@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

[ Upstream commit 8120bd469f5525da229953c1197f2b826c0109f4 ]

Free the kbuf buffer before returning from the dpaa2_console_read()
function. The variable no longer goes out of scope, leaking the storage
it points to.

Fixes: c93349d8c170 ("soc: fsl: add DPAA2 console support")
Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/dpaa2-console.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/fsl/dpaa2-console.c b/drivers/soc/fsl/dpaa2-console.c
index 27243f706f376..53917410f2bdb 100644
--- a/drivers/soc/fsl/dpaa2-console.c
+++ b/drivers/soc/fsl/dpaa2-console.c
@@ -231,6 +231,7 @@ static ssize_t dpaa2_console_read(struct file *fp, char __user *buf,
 	cd->cur_ptr += bytes;
 	written += bytes;
 
+	kfree(kbuf);
 	return written;
 
 err_free_buf:
-- 
2.33.0




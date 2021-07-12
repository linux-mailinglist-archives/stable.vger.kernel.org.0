Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18553C5098
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344719AbhGLHdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345178AbhGLH3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 107C061221;
        Mon, 12 Jul 2021 07:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074758;
        bh=sooO2MLxM7bLD2+xTCs+FYPJ7Y621Jb1smqCOhz/UK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFQLWW6KA/V4mtVplRosdhN1fqo5Cx6fbkaqQN835SM9XvC6lcbvJEFDJ5UrNpOb2
         EFobUEeYKFGz61XJyESmYGAhNg63/x4Yy+a5M2GlNQIziU4ZcNYduCkxeGY1/S0fJa
         HYILIOzkLhR3pPDfPohnaRdJWJqA7AIS6oCE6wuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH 5.12 688/700] mailbox: qcom-ipcc: Fix IPCC mbox channel exhaustion
Date:   Mon, 12 Jul 2021 08:12:51 +0200
Message-Id: <20210712061049.144299677@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

commit d6fbfdbc12745ce24bcd348dbf7e652353b3e59c upstream.

Fix IPCC (Inter-Processor Communication Controller) channel exhaustion by
setting the channel private data to NULL on mbox shutdown.

Err Logs:
remoteproc: MBA booted without debug policy, loading mpss
remoteproc: glink-edge: failed to acquire IPC channel
remoteproc: failed to probe subdevices for remoteproc: -16

Fixes: fa74a0257f45 ("mailbox: Add support for Qualcomm IPCC")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Cc: stable@vger.kernel.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mailbox/qcom-ipcc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -155,6 +155,11 @@ static int qcom_ipcc_mbox_send_data(stru
 	return 0;
 }
 
+static void qcom_ipcc_mbox_shutdown(struct mbox_chan *chan)
+{
+	chan->con_priv = NULL;
+}
+
 static struct mbox_chan *qcom_ipcc_mbox_xlate(struct mbox_controller *mbox,
 					const struct of_phandle_args *ph)
 {
@@ -184,6 +189,7 @@ static struct mbox_chan *qcom_ipcc_mbox_
 
 static const struct mbox_chan_ops ipcc_mbox_chan_ops = {
 	.send_data = qcom_ipcc_mbox_send_data,
+	.shutdown = qcom_ipcc_mbox_shutdown,
 };
 
 static int qcom_ipcc_setup_mbox(struct qcom_ipcc *ipcc)



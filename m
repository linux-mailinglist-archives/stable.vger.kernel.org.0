Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529881C44D9
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgEDSFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731756AbgEDSFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86816206B8;
        Mon,  4 May 2020 18:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615501;
        bh=2r32fugBjwG8T40ehjInEQQbqeH50pAvIpYorokJkRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rLckBcNpyo7oviNpnBLD2VPhqRM7Xmt+bhWGdbCQNmc2izIS2ZoG+/mn1j9w5FQAK
         10hAggZu2mAudEUU1rfrZh11guD+uJwAFnsO0Yd61kFFYlHHx0eox7eGIh5ciP+Rhh
         GfIs80BaaBaHMjkauJ7CBqd//gqTdZ7zHArbVI0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 35/57] scsi: qla2xxx: check UNLOADING before posting async work
Date:   Mon,  4 May 2020 19:57:39 +0200
Message-Id: <20200504165459.394512123@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

commit 5a263892d7d0b4fe351363f8d1a14c6a75955475 upstream.

qlt_free_session_done() tries to post async PRLO / LOGO, and waits for the
completion of these async commands. If UNLOADING is set, this is doomed to
timeout, because the async logout command will never complete.

The only way to avoid waiting pointlessly is to fail posting these commands
in the first place if the driver is in UNLOADING state.  In general,
posting any command should be avoided when the driver is UNLOADING.

With this patch, "rmmod qla2xxx" completes without noticeable delay.

Link: https://lore.kernel.org/r/20200421204621.19228-3-mwilck@suse.com
Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Acked-by: Arun Easi <aeasi@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_os.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4857,6 +4857,9 @@ qla2x00_alloc_work(struct scsi_qla_host
 	struct qla_work_evt *e;
 	uint8_t bail;
 
+	if (test_bit(UNLOADING, &vha->dpc_flags))
+		return NULL;
+
 	QLA_VHA_MARK_BUSY(vha, bail);
 	if (bail)
 		return NULL;



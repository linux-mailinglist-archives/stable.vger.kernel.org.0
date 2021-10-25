Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6C643A373
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbhJYT7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238668AbhJYT42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:56:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABAAA6128C;
        Mon, 25 Oct 2021 19:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191195;
        bh=psDtAvh1TrzagLOYDXFIoST01HStKT0CyZ8mpVr1Y3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EetFx8rtzQi0TNzGhKWJow89rogwIXoj9s9bGJQlLo0tg7fzWCTevRGD9U2BJeOVl
         zGc+Cr39oFsg/S6lHg80lHC10/D3BLOihivUvnKFB1mitAx50hUyQhy6IADIL6X+CY
         fKNw5HJWeo0lYzSOmelnwFCjUvwhhQEG4oOhgkvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Li Feng <fengli@smartx.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 149/169] scsi: iscsi: Fix set_param() handling
Date:   Mon, 25 Oct 2021 21:15:30 +0200
Message-Id: <20211025191036.443023286@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 187a580c9e7895978dcd1e627b9c9e7e3d13ca96 ]

In commit 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and
sync thread") we meant to add a check where before we call ->set_param() we
make sure the iscsi_cls_connection is bound. The problem is that between
versions 4 and 5 of the patch the deletion of the unchecked set_param()
call was dropped so we ended up with 2 calls. As a result we can still hit
a crash where we access the unbound connection on the first call.

This patch removes that first call.

Fixes: 9e67600ed6b8 ("scsi: iscsi: Fix race condition between login and sync thread")
Link: https://lore.kernel.org/r/20211010161904.60471-1-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Li Feng <fengli@smartx.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 922e4c7bd88e..78343d3f9385 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2930,8 +2930,6 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
-		err = transport->set_param(conn, ev->u.set_param.param,
-					   data, ev->u.set_param.len);
 		if ((conn->state == ISCSI_CONN_BOUND) ||
 			(conn->state == ISCSI_CONN_UP)) {
 			err = transport->set_param(conn, ev->u.set_param.param,
-- 
2.33.0




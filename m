Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3521438EFD2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhEXP7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:41186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234830AbhEXP7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E306197D;
        Mon, 24 May 2021 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871090;
        bh=0/p0tc9WrNj0jr3ZyF9G/zdESfFGAEkfgCe3qd7ps5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwPK9pFM7r06gbr/8I2z9zsM+eGsxYTafVVvDnrXzpoUope+GMgBgjvbx1iUmlbFQ
         tp7b3BPW9nJ+3KPK8AuVkEQP66oB5h+FXurDG7KQGtmDHMKncDbNpk/kvmFqwe7G21
         SUVqaN82WV58YqJQj8HPrsh/WVLeE2iASCMhnoLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 5.12 061/127] uio_hv_generic: Fix a memory leak in error handling paths
Date:   Mon, 24 May 2021 17:26:18 +0200
Message-Id: <20210524152336.896674027@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 3ee098f96b8b6c1a98f7f97915f8873164e6af9d upstream.

If 'vmbus_establish_gpadl()' fails, the (recv|send)_gpadl will not be
updated and 'hv_uio_cleanup()' in the error handling path will not be
able to free the corresponding buffer.

In such a case, we need to free the buffer explicitly.

Fixes: cdfa835c6e5e ("uio_hv_generic: defer opening vmbus until first use")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/4fdaff557deef6f0475d02ba7922ddbaa1ab08a6.1620544055.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_hv_generic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/uio/uio_hv_generic.c
+++ b/drivers/uio/uio_hv_generic.c
@@ -296,8 +296,10 @@ hv_uio_probe(struct hv_device *dev,
 
 	ret = vmbus_establish_gpadl(channel, pdata->recv_buf,
 				    RECV_BUFFER_SIZE, &pdata->recv_gpadl);
-	if (ret)
+	if (ret) {
+		vfree(pdata->recv_buf);
 		goto fail_close;
+	}
 
 	/* put Global Physical Address Label in name */
 	snprintf(pdata->recv_name, sizeof(pdata->recv_name),
@@ -316,8 +318,10 @@ hv_uio_probe(struct hv_device *dev,
 
 	ret = vmbus_establish_gpadl(channel, pdata->send_buf,
 				    SEND_BUFFER_SIZE, &pdata->send_gpadl);
-	if (ret)
+	if (ret) {
+		vfree(pdata->send_buf);
 		goto fail_close;
+	}
 
 	snprintf(pdata->send_name, sizeof(pdata->send_name),
 		 "send:%u", pdata->send_gpadl);



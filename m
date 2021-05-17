Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C23383800
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245167AbhEQPsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345021AbhEQPqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:46:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B37761954;
        Mon, 17 May 2021 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262654;
        bh=9e1NpktBaQxCEzNSTtXQpzNt52VY3DIH7mIJyie7GNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDOd3RbObhw6fleigVvLX3k9IPgFj/1z1XPO10uGDPjIEuc5rsgy3hx9B1R3zodHe
         OO7+TeXQShYgW9HYMrePqLy7NrE6CekwTpvamTOLS1lK63E4BQUjPpeVz2ap1s1I5S
         R+rb239tuly/1tOc+1wbv0R7LR2JFrqqNy/P1iZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 5.10 248/289] usb: typec: ucsi: Put fwnode in any case during ->probe()
Date:   Mon, 17 May 2021 16:02:53 +0200
Message-Id: <20210517140313.493562254@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

commit b9a0866a5bdf6a4643a52872ada6be6184c6f4f2 upstream.

device_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210504222337.3151726-1-andy.shevchenko@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -910,6 +910,7 @@ static const struct typec_operations ucs
 	.pr_set = ucsi_pr_swap
 };
 
+/* Caller must call fwnode_handle_put() after use */
 static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
 {
 	struct fwnode_handle *fwnode;
@@ -943,7 +944,7 @@ static int ucsi_register_port(struct ucs
 	command |= UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &con->cap, sizeof(con->cap));
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 
 	if (con->cap.op_mode & UCSI_CONCAP_OPMODE_DRP)
 		cap->data = TYPEC_PORT_DRD;
@@ -1039,6 +1040,8 @@ static int ucsi_register_port(struct ucs
 	trace_ucsi_register_port(con->num, &con->status);
 
 out:
+	fwnode_handle_put(cap->fwnode);
+out_unlock:
 	mutex_unlock(&con->lock);
 	return ret;
 }



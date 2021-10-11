Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1944B428F43
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbhJKN4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:56:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237818AbhJKNyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FE1610C7;
        Mon, 11 Oct 2021 13:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960351;
        bh=hxLPLFEEOip7IrS/05/cNzSz8oozAA/DJyozwFDDfSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgkGysMkDAAQQSguUJWrhy/+jr5kM9t0ipZ+VXInhUu03ZZjv9LLwTSij3tbRXpEu
         H+pB7fcBu7WRV7PKQOMhe/OWgp62RcRO+Gw9ZxZnrqI508bcDGgOwl9p8NiIIL2jiA
         sdTwSZ0VEFr/uB8ceuaBKsdLjYsrKH5rLyzyAmmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.10 05/83] usb: typec: tcpm: handle SRC_STARTUP state if cc changes
Date:   Mon, 11 Oct 2021 15:45:25 +0200
Message-Id: <20211011134508.543738609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Yang <xu.yang_2@nxp.com>

commit 6d91017a295e9790eec02c4e43f020cdb55f5d98 upstream.

TCPM for DRP should do the same action as SRC_ATTACHED when cc changes in
SRC_STARTUP state. Otherwise, TCPM will transition to SRC_UNATTACHED state
which is not satisfied with the Type-C spec.

Per Type-C spec:
DRP port should move to Unattached.SNK instead of Unattached.SRC if sink
removed.

Fixes: 4b4e02c83167 ("typec: tcpm: Move out of staging")
cc: <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20210928111639.3854174-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3922,6 +3922,7 @@ static void _tcpm_cc_change(struct tcpm_
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		break;
 	case SRC_ATTACHED:
+	case SRC_STARTUP:
 	case SRC_SEND_CAPABILITIES:
 	case SRC_READY:
 		if (tcpm_port_is_disconnected(port) ||



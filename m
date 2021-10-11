Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16502428EC0
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237488AbhJKNvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237242AbhJKNvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C8CE60F38;
        Mon, 11 Oct 2021 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960121;
        bh=v+dY2MuQxZmqnXrELfYOYo3g30WZSiidau+1ykncHWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnGOMaqxw7A/xQ8gUyqNOOup8OeJVmNib6++JOI/BGumq4mx51WyCKq599wmZzTRv
         q898WTWz7qJMRrqiNfe5rv2bVBwMxL4R4G2UFO6xUekpGGWrUn0wYbbp57Brs08aXr
         g8aLGuAgdHPxPPguhPAOJ92USL+bhWkJRINjhxJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.4 04/52] usb: typec: tcpm: handle SRC_STARTUP state if cc changes
Date:   Mon, 11 Oct 2021 15:45:33 +0200
Message-Id: <20211011134503.872744015@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
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
@@ -3679,6 +3679,7 @@ static void _tcpm_cc_change(struct tcpm_
 			tcpm_set_state(port, SRC_ATTACH_WAIT, 0);
 		break;
 	case SRC_ATTACHED:
+	case SRC_STARTUP:
 	case SRC_SEND_CAPABILITIES:
 	case SRC_READY:
 		if (tcpm_port_is_disconnected(port) ||



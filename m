Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7515037C6BF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhELPx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235876AbhELPti (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:49:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E505619CD;
        Wed, 12 May 2021 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833137;
        bh=K08fhwKVxiFMdIbcPy6DqeaAO5mzbxQk0ABuoa2iwtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yEcZKXz/u20ut5BRp2ipbjrfKYWNBlmJPBjCsMDkNlMebtf4r/H7tWQIAVuY0U4Xr
         Gr4gvlvFtQoNJO/orPA6HA03AsgzZ27z0aRegD0N3gL0TZONY2XXuHl3xq151UFg/r
         NzRkjT0dndLXlGqscIyaIrrpd7im1CwuiHh24MYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 008/601] tty: amiserial: fix TIOCSSERIAL permission check
Date:   Wed, 12 May 2021 16:41:25 +0200
Message-Id: <20210512144828.098505937@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 1d31a831cc04f5f942de3e7d91edaa52310d3c99 upstream.

Changing the port closing_wait parameter is a privileged operation.

Add the missing check to TIOCSSERIAL so that -EPERM is returned in case
an unprivileged user tries to change the closing-wait setting.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-9-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/amiserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -970,6 +970,7 @@ static int set_serial_info(struct tty_st
 	if (!serial_isroot()) {
 		if ((ss->baud_base != state->baud_base) ||
 		    (ss->close_delay != port->close_delay) ||
+		    (ss->closing_wait != port->closing_wait) ||
 		    (ss->xmit_fifo_size != state->xmit_fifo_size) ||
 		    ((ss->flags & ~ASYNC_USR_MASK) !=
 		     (port->flags & ~ASYNC_USR_MASK))) {



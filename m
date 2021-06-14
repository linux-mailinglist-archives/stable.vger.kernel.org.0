Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922CE3A6488
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhFNL0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236096AbhFNLYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E61061414;
        Mon, 14 Jun 2021 10:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668007;
        bh=jQO9E+9q2/Ot2x+VSJNydxOeRbcywOkNncQqemb1AgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjfM9Er1bx5TfigW3HgUWL7S69u/nVRPXfcIuYXaSmmOIt/BwOFqIDAssDj8+XwJq
         NiRTzqKiOnj93U5NtHcXeUkGS2u+by7uRrWU5GQocwyLG8A1DylHH+8Uug+z5Il/M6
         SkVYNu4Gc5ymFpnOnQl/2sq5M0VY3Zhr++O1ocEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.12 158/173] platform/surface: aggregator: Fix event disable function
Date:   Mon, 14 Jun 2021 12:28:10 +0200
Message-Id: <20210614102703.424599573@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit b430e1d65ef6eeee42c4e53028f8dfcc6abc728b upstream.

Disabling events silently fails due to the wrong command ID being used.
Instead of the command ID for the disable call, the command ID for the
enable call was being used. This causes the disable call to enable the
event instead. As the event is already enabled when we call this
function, the EC silently drops this command and does nothing.

Use the correct command ID for disabling the event to fix this.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20210603000636.568846-1-luzmaximilian@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/surface/aggregator/controller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/surface/aggregator/controller.c
+++ b/drivers/platform/surface/aggregator/controller.c
@@ -1907,7 +1907,7 @@ static int ssam_ssh_event_disable(struct
 {
 	int status;
 
-	status = __ssam_ssh_event_request(ctrl, reg, reg.cid_enable, id, flags);
+	status = __ssam_ssh_event_request(ctrl, reg, reg.cid_disable, id, flags);
 
 	if (status < 0 && status != -EINVAL) {
 		ssam_err(ctrl,



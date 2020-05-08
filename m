Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04B1CAB5F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgEHMnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgEHMnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9D4624968;
        Fri,  8 May 2020 12:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941781;
        bh=SRf+a/x2mhrkqpjLlCdHr3nnCS44RaW/UzT8W01MYRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFCb9n2p6d/y31bWDYTlVom7hJN2miTZt+WC3uZQ7wW4R0jdD9ji3mW6q0kuHWMzP
         tezzwmfAOc3NgI5N6ND493tcj2vLqg76BL47HLXulOjUVTjRFJINrS+ux1f0SfFNSh
         bLwZqAeACGEa6xlqalxcCoFwgLotWnOd6sDRjd5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 4.4 169/312] [media] rc: allow rc modules to be loaded if rc-main is not a module
Date:   Fri,  8 May 2020 14:32:40 +0200
Message-Id: <20200508123136.366163122@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 2ff56fadd94cdaeeaeccbc0a9b703a0101ada128 upstream.

rc-main mistakenly uses #ifdef MODULE to determine whether it should
load the rc keymap modules.  This symbol is only defined if rc-main
is being built as a module itself, and bears no relation to whether
the rc keymaps are modules.

Fix this to use CONFIG_MODULES instead.

Fixes: 631493ecacd8 ("[media] rc-core: merge rc-map.c into rc-main.c")

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/rc/rc-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -61,7 +61,7 @@ struct rc_map *rc_map_get(const char *na
 	struct rc_map_list *map;
 
 	map = seek_rc_map(name);
-#ifdef MODULE
+#ifdef CONFIG_MODULES
 	if (!map) {
 		int rc = request_module("%s", name);
 		if (rc < 0) {



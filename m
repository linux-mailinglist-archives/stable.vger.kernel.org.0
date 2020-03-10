Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E41817FCC3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgCJNAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbgCJM7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:59:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EB432468C;
        Tue, 10 Mar 2020 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845185;
        bh=u5EESKKXh5N8XxF1ERwT6O7rJ8l+e6cksy9HpYkORGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9xA+Db1XkN4FhxtOWkn9BLJWqA5c5AW2nZxgdl9LlCPpDkkiXOKDpEhadwS1BGfl
         hQD1yzFSsI06Nl5kFZUpYC8tIT1YVF2wO40GTCgMRWpCB42ktzjrLDimGhQvnlhNHB
         poSe+FLKExAS/70qE65Zc469FLFOuu2eGQfHFJBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.5 075/189] usb: core: hub: fix unhandled return by employing a void function
Date:   Tue, 10 Mar 2020 13:38:32 +0100
Message-Id: <20200310123647.200239875@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

commit 63d6d7ed475c53dc1cabdfedf63de1fd8dcd72ee upstream.

Address below Coverity complaint (Feb 25, 2020, 8:06 AM CET):

---
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1866,7 +1866,7 @@ static int hub_probe(struct usb_interfac
 
 	if (id->driver_info & HUB_QUIRK_DISABLE_AUTOSUSPEND) {
 		hub->quirk_disable_autosuspend = 1;
-		usb_autopm_get_interface(intf);
+		usb_autopm_get_interface_no_resume(intf);
 	}
 
 	if (hub_configure(hub, &desc->endpoint[0].desc) >= 0)



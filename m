Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D541FBB50
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbgFPPh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbgFPPh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:37:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA91C20B1F;
        Tue, 16 Jun 2020 15:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321878;
        bh=Lq0rzd8/VWyjqzu7gI6W77XhrAJW8U6FGO1gnHwgDWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGG14uTMZUUgiGEr7jgkex61hPHlMHAxE3WNNPkW64uwxrP9W1gq7ZxwsPWl0O4OS
         SjNevqU0cP620kdp9/qYAOOEzfJLk+M+pWJq//5JZ0csV8tpp3YE7LrhC4r2JAV4hN
         KlMDpT3JHrl2xR9eob+M8Y4NKl0W4xbDPK0WZIBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hill Ma <maahiuzeon@gmail.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 043/134] x86/reboot/quirks: Add MacBook6,1 reboot quirk
Date:   Tue, 16 Jun 2020 17:33:47 +0200
Message-Id: <20200616153102.858974098@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hill Ma <maahiuzeon@gmail.com>

commit 140fd4ac78d385e6c8e6a5757585f6c707085f87 upstream.

On MacBook6,1 reboot would hang unless parameter reboot=pci is added.
Make it automatic.

Signed-off-by: Hill Ma <maahiuzeon@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200425200641.GA1554@cslab.localdomain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -197,6 +197,14 @@ static const struct dmi_system_id reboot
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
 		},
 	},
+	{	/* Handle problems with rebooting on Apple MacBook6,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBook6,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook6,1"),
+		},
+	},
 	{	/* Handle problems with rebooting on Apple MacBookPro5 */
 		.callback = set_pci_reboot,
 		.ident = "Apple MacBookPro5",



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E3218B7B2
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgCSNLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:11:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbgCSNLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:11:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00CE920722;
        Thu, 19 Mar 2020 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623506;
        bh=dhGUR4xatn233XksUDPF0ILpwQzNjiz/U8o9OsPwpEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2pC+0do0qOR4EP6qk7PLr1V8SyZX+tSnKc9ZGnY9+OQxz1ZMWWHeAUPdBbjzrnFR
         AszoyHPFiWZSoqS1TQbL0maztl06sIWuzKWWayLmdc2PsZ2LzBZvZ/9bkwBr8LawEu
         g7HwRU+ArX4pOyWPFGrNzFcjWKgHAD7wCwKDzJZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.9 50/90] efi: Add a sanity check to efivar_store_raw()
Date:   Thu, 19 Mar 2020 14:00:12 +0100
Message-Id: <20200319123943.933764358@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123928.635114118@linuxfoundation.org>
References: <20200319123928.635114118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladis Dronov <vdronov@redhat.com>

commit d6c066fda90d578aacdf19771a027ed484a79825 upstream.

Add a sanity check to efivar_store_raw() the same way
efivar_{attr,size,data}_read() and efivar_show_raw() have it.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200305084041.24053-3-vdronov@redhat.com
Link: https://lore.kernel.org/r/20200308080859.21568-25-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/firmware/efi/efivars.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -272,6 +272,9 @@ efivar_store_raw(struct efivar_entry *en
 	u8 *data;
 	int err;
 
+	if (!entry || !buf)
+		return -EINVAL;
+
 	if (is_compat()) {
 		struct compat_efi_variable *compat;
 



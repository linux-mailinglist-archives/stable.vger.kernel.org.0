Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7AD186BEB
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 14:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgCPNUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 09:20:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21833 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731220AbgCPNUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 09:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584364816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQwqxNqYVBIK/xPUBIRHGl2zd/4qvJLb301TbJv/yzw=;
        b=FZCWfa9QFTUHMVkzNfNsT9kx4E1Jt+TMcQiv9+d0buwbnq8a+In+xSVjYBFDJkA1aMIl2R
        cl3jfVET0Da+0qlRcl0+T9crDajdEVE81KeAFU8NxBZWRat5j1nLlprtntWiBGgYkqTJyv
        Q6KZYqo3DWCDz2sZq2MhKNXPukkR+co=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-DOF69XjjPJe7-TkIzVQGvQ-1; Mon, 16 Mar 2020 09:20:11 -0400
X-MC-Unique: DOF69XjjPJe7-TkIzVQGvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 388451034B04;
        Mon, 16 Mar 2020 13:20:10 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-205-4.brq.redhat.com [10.40.205.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5D705DA81;
        Mon, 16 Mar 2020 13:20:07 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19, 4.14, 4.9, 4.4 2/2] efi: Add a sanity check to efivar_store_raw()
Date:   Mon, 16 Mar 2020 14:19:38 +0100
Message-Id: <20200316131938.31453-3-vdronov@redhat.com>
In-Reply-To: <20200316131938.31453-1-vdronov@redhat.com>
References: <20200316131938.31453-1-vdronov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d6c066fda90d578aacdf19771a027ed484a79825 upstream.

Add a sanity check to efivar_store_raw() the same way
efivar_{attr,size,data}_read() and efivar_show_raw() have it.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200305084041.24053-3-vdronov@redhat.com
Link: https://lore.kernel.org/r/20200308080859.21568-25-ardb@kernel.org
---
 drivers/firmware/efi/efivars.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivar=
s.c
index c8688490f148..1c65f5ac4368 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -272,6 +272,9 @@ efivar_store_raw(struct efivar_entry *entry, const ch=
ar *buf, size_t count)
 	u8 *data;
 	int err;
=20
+	if (!entry || !buf)
+		return -EINVAL;
+
 	if (is_compat()) {
 		struct compat_efi_variable *compat;
=20
--=20
2.20.1


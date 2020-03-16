Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64620186BE9
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 14:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbgCPNUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 09:20:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55038 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731103AbgCPNUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 09:20:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584364805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=trIp9mUUCYJ0vq+R8H0+fNR2GWtBwNeZkcRV0+9VowI=;
        b=evh01qVxQii0Bo9pJTlQxboSZEgJwvJjRhQ/Wz1F1BqPkpezg4bIPv7vBvElyDfq69CJs0
        UUkN4e30sLzhupZx+18fdPdv7Vag+GPPMcN8IpjoJreEztLx4aTDoGYR97KaxQGYQHS3Gg
        vQ69GONfiCqbUHoRyPmkxGglGujjcXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-b4bLRiNmNiygdXZGkWL0-g-1; Mon, 16 Mar 2020 09:20:03 -0400
X-MC-Unique: b4bLRiNmNiygdXZGkWL0-g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C088B149C9;
        Mon, 16 Mar 2020 13:20:02 +0000 (UTC)
Received: from rules.brq.redhat.com (ovpn-205-4.brq.redhat.com [10.40.205.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D4165DA7C;
        Mon, 16 Mar 2020 13:19:59 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19, 4.14, 4.9, 4.4 0/2] efi: fix a race and add a sanity check
Date:   Mon, 16 Mar 2020 14:19:36 +0100
Message-Id: <20200316131938.31453-1-vdronov@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is a race and a buffer overflow while reading an efi variable
and the first patch fixes it. The second patch adds a sanity check
to efivar_store_raw(). The original patchset applies to the 5.x trees
fine.

Vladis Dronov (2):
  efi: fix a race and a buffer overflow while reading efivars via sysfs
  efi: add a sanity check to efivar_store_raw()

 drivers/firmware/efi/efivars.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)


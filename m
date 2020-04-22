Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8FB1B4202
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgDVKEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:04:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbgDVKD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:03:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77D2A2076C;
        Wed, 22 Apr 2020 10:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549838;
        bh=fJ96WCz+iWlr15uyMV2Md/i5n39XXHJodgUn1hJAodo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/WAoO79fPOBCL+2DEdpEeJSxBAJRifQz105yab9DEC3KJBNIPL7wsGH2hFt8xrcQ
         IgXwX5KrZ3V0jXgFruKipu2aVPQoi0oSdAc2jYY6SaviJILIDXuP15HjrC3mQUgCwZ
         WSCGZ0z4oQWnsBI5qUzh7yfcBmET2iGXzwJsJnkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 027/125] acpi/x86: ignore unspecified bit positions in the ACPI global lock field
Date:   Wed, 22 Apr 2020 11:55:44 +0200
Message-Id: <20200422095037.710919282@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095032.909124119@linuxfoundation.org>
References: <20200422095032.909124119@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Engelhardt <jengelh@inai.de>

commit ecb9c790999fd6c5af0f44783bd0217f0b89ec2b upstream.

The value in "new" is constructed from "old" such that all bits defined
as reserved by the ACPI spec[1] are left untouched. But if those bits
do not happen to be all zero, "new < 3" will not evaluate to true.

The firmware of the laptop(s) Medion MD63490 / Akoya P15648 comes with
garbage inside the "FACS" ACPI table. The starting value is
old=0x4944454d, therefore new=0x4944454e, which is >= 3. Mask off
the reserved bits.

[1] https://uefi.org/sites/default/files/resources/ACPI_6_2.pdf

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206553
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1717,7 +1717,7 @@ int __acpi_acquire_global_lock(unsigned
 		new = (((old & ~0x3) + 2) + ((old >> 1) & 0x1));
 		val = cmpxchg(lock, old, new);
 	} while (unlikely (val != old));
-	return (new < 3) ? -1 : 0;
+	return ((new & 0x3) < 3) ? -1 : 0;
 }
 
 int __acpi_release_global_lock(unsigned int *lock)



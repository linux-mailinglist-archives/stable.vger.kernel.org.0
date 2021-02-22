Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7238321609
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhBVMQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhBVMPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DCF464E4B;
        Mon, 22 Feb 2021 12:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996077;
        bh=JzL1R1kLFmc4+X+GW/BnLIETWiIar3H27kZ/NPvXEQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHY5B8BhYpGUEoGKTXVHfGJTkoJ0C2YB4utVyKOF/p0nd/BHQ9DpGXHuq1EmpF8Zi
         e90QWC1BI9FE7yHQo+ewsST8+GsCojnXMCR0sBbcOD+4PRMTX762kIgpdFStSbl+Bl
         KSADdt+rIR/DhS9pTxgOKrCZkyEuRJSgw6qwNklQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Julien Grall <jgrall@amazon.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 20/29] xen/arm: dont ignore return errors from set_phys_to_machine
Date:   Mon, 22 Feb 2021 13:13:14 +0100
Message-Id: <20210222121024.069807102@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@xilinx.com>

commit 36bf1dfb8b266e089afa9b7b984217f17027bf35 upstream.

set_phys_to_machine can fail due to lack of memory, see the kzalloc call
in arch/arm/xen/p2m.c:__set_phys_to_machine_multi.

Don't ignore the potential return error in set_foreign_p2m_mapping,
returning it to the caller instead.

This is part of XSA-361.

Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
Cc: stable@vger.kernel.org
Reviewed-by: Julien Grall <jgrall@amazon.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/xen/p2m.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -95,8 +95,10 @@ int set_foreign_p2m_mapping(struct gntta
 	for (i = 0; i < count; i++) {
 		if (map_ops[i].status)
 			continue;
-		set_phys_to_machine(map_ops[i].host_addr >> XEN_PAGE_SHIFT,
-				    map_ops[i].dev_bus_addr >> XEN_PAGE_SHIFT);
+		if (unlikely(!set_phys_to_machine(map_ops[i].host_addr >> XEN_PAGE_SHIFT,
+				    map_ops[i].dev_bus_addr >> XEN_PAGE_SHIFT))) {
+			return -ENOMEM;
+		}
 	}
 
 	return 0;



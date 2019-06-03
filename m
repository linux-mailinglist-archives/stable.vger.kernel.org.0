Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0FCA32BDF
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbfFCJMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbfFCJMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:12:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8860627EA5;
        Mon,  3 Jun 2019 09:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553136;
        bh=s5XUr4oAMYMkO/L1yXi+KcIP++cyMJwnAPtD+Pi+5qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XnsCNwFOjME/qB/m55JdgAAvaiy0IZVr+YlrV27gUPEv5pZZgMEUgbCVbIdB2r78B
         tnGGoEokeB5LVtjcRV32murOMFac44K7r4UiqksOKpj27wkhrA5GOR22DcZLbcrTbP
         QU39ekrOsRaKSXlgdsm4pj/CN6JZCzE00RHdUBvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 5.0 34/36] xen/pciback: Dont disable PCI_COMMAND on PCI device reset.
Date:   Mon,  3 Jun 2019 11:09:22 +0200
Message-Id: <20190603090523.223934283@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 7681f31ec9cdacab4fd10570be924f2cef6669ba upstream.

There is no need for this at all. Worst it means that if
the guest tries to write to BARs it could lead (on certain
platforms) to PCI SERR errors.

Please note that with af6fc858a35b90e89ea7a7ee58e66628c55c776b
"xen-pciback: limit guest control of command register"
a guest is still allowed to enable those control bits (safely), but
is not allowed to disable them and that therefore a well behaved
frontend which enables things before using them will still
function correctly.

This is done via an write to the configuration register 0x4 which
triggers on the backend side:
command_write
  \- pci_enable_device
     \- pci_enable_device_flags
        \- do_pci_enable_device
           \- pcibios_enable_device
              \-pci_enable_resourcess
                [which enables the PCI_COMMAND_MEMORY|PCI_COMMAND_IO]

However guests (and drivers) which don't do this could cause
problems, including the security issues which XSA-120 sought
to address.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-pciback/pciback_ops.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -127,8 +127,6 @@ void xen_pcibk_reset_device(struct pci_d
 		if (pci_is_enabled(dev))
 			pci_disable_device(dev);
 
-		pci_write_config_word(dev, PCI_COMMAND, 0);
-
 		dev->is_busmaster = 0;
 	} else {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);



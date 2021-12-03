Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3032467E71
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 20:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353476AbhLCTxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 14:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353441AbhLCTxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Dec 2021 14:53:19 -0500
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC54C061751
        for <stable@vger.kernel.org>; Fri,  3 Dec 2021 11:49:54 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 04591100AF5DC;
        Fri,  3 Dec 2021 20:49:51 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id D7286240DD0; Fri,  3 Dec 2021 20:49:50 +0100 (CET)
Date:   Fri, 3 Dec 2021 20:49:50 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        linux-pci@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] PCI: pciehp: Use down_read/write_nested(reset_lock)
 to fix lockdep errors
Message-ID: <20211203194950.GB9627@wunner.de>
References: <20211202123415.25737-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202123415.25737-1-hdegoede@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 02, 2021 at 01:34:15PM +0100, Hans de Goede wrote:
> Use down_read_nested() and down_write_nested() when taking the
> ctrl->reset_lock rw-sem, passing the number of PCIe hotplug controllers in
> the path to the PCI root bus as lock subclass parameter. This fixes the
> following false-positive lockdep report when unplugging a Lenovo X1C8 from
> a Lenovo 2nd gen TB3 dock:
[...]
> Link: https://lore.kernel.org/linux-pci/20190402021933.GA2966@mit.edu/
> Link: https://lore.kernel.org/linux-pci/de684a28-9038-8fc6-27ca-3f6f2f6400d7@redhat.com/
> Cc: stable@vger.kernel.org
> Reported-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Reviewed-by: Lukas Wunner <lukas@wunner.de>

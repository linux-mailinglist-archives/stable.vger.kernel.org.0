Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221C812F0A6
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgABWUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728053AbgABWUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:20:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42AC621582;
        Thu,  2 Jan 2020 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003610;
        bh=BmOf4eX506gey7d/fY6qrWHZaCqMP9oFOn8fOgVOkiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6J/FSYmlmnfmqUnhUOVmR+CFm5ElRIZSslti9VNotY3AWZa8vnCoeJL16uwEJsPh
         onuLbmkoUGzXQRba95FGXNfbOvvqjUvF6JRuiiyNJ84nsP42/+vk/4E3NC4gSeBdAF
         W92xNhXMYPfzG+CAAj3sKsCZtVeNyAjjoA/bX6mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/114] PCI: rpaphp: Correctly match ibm, my-drc-index to drc-name when using drc-info
Date:   Thu,  2 Jan 2020 23:06:52 +0100
Message-Id: <20200102220033.132193106@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 4f9f2d3d7a434b7f882b72550194c9278f4a3925 ]

The newer ibm,drc-info property is a condensed description of the old
ibm,drc-* properties (ie. names, types, indexes, and power-domains).
When matching a drc-index to a drc-name we need to verify that the
index is within the start and last drc-index range and map it to a
drc-name using the drc-name-prefix and logical index.

Fix the mapping by checking that the index is within the range of the
current drc-info entry, and build the name from the drc-name-prefix
concatenated with the starting drc-name-suffix value and the sequential
index obtained by subtracting ibm,my-drc-index from this entries
drc-start-index.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1573449697-5448-10-git-send-email-tyreld@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/rpaphp_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
index 7d74fe875225..a306cad70470 100644
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -248,9 +248,10 @@ static int rpaphp_check_drc_props_v2(struct device_node *dn, char *drc_name,
 		/* Should now know end of current entry */
 
 		/* Found it */
-		if (my_index <= drc.last_drc_index) {
+		if (my_index >= drc.drc_index_start && my_index <= drc.last_drc_index) {
+			int index = my_index - drc.drc_index_start;
 			sprintf(cell_drc_name, "%s%d", drc.drc_name_prefix,
-				my_index);
+				drc.drc_name_suffix_start + index);
 			break;
 		}
 	}
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA80A12EC9C
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgABWUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:20:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728739AbgABWUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:20:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C119B22525;
        Thu,  2 Jan 2020 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003608;
        bh=2idXf988AH2BgbA+RFheSDzupFk2EiecZ2E97rSpuo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loTBqxV+lZNaQ02NxzR7DTN/WWQnHiEjPOPVbiDvj+9NHx+7UBlREHn6/EVbbLWex
         2KpXCdYc4gqpiqp+K6eGdraLD2Kp7tXpW4ps8tnNAMkfc+HZZUXhjcsNyunVGWWAuQ
         PN/lEKlFti6INtVtHZsQWhtxlDFXJg4q1RayOVhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/114] PCI: rpaphp: Annotate and correctly byte swap DRC properties
Date:   Thu,  2 Jan 2020 23:06:51 +0100
Message-Id: <20200102220033.048120228@linuxfoundation.org>
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

[ Upstream commit 0737686778c6dbe0908d684dd5b9c05b127526ba ]

The device tree is in big endian format and any properties directly
retrieved using OF helpers that don't explicitly byte swap should
be annotated. In particular there are several places where we grab
the opaque property value for the old ibm,drc-* properties and the
ibm,my-drc-index property.

Fix this for better static checking by annotating values we know to
explicitly big endian, and byte swap where appropriate.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1573449697-5448-9-git-send-email-tyreld@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/rpaphp_core.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
index ccc6deeb9ccf..7d74fe875225 100644
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -154,11 +154,11 @@ static enum pci_bus_speed get_max_bus_speed(struct slot *slot)
 	return speed;
 }
 
-static int get_children_props(struct device_node *dn, const int **drc_indexes,
-		const int **drc_names, const int **drc_types,
-		const int **drc_power_domains)
+static int get_children_props(struct device_node *dn, const __be32 **drc_indexes,
+			      const __be32 **drc_names, const __be32 **drc_types,
+			      const __be32 **drc_power_domains)
 {
-	const int *indexes, *names, *types, *domains;
+	const __be32 *indexes, *names, *types, *domains;
 
 	indexes = of_get_property(dn, "ibm,drc-indexes", NULL);
 	names = of_get_property(dn, "ibm,drc-names", NULL);
@@ -194,8 +194,8 @@ static int rpaphp_check_drc_props_v1(struct device_node *dn, char *drc_name,
 				char *drc_type, unsigned int my_index)
 {
 	char *name_tmp, *type_tmp;
-	const int *indexes, *names;
-	const int *types, *domains;
+	const __be32 *indexes, *names;
+	const __be32 *types, *domains;
 	int i, rc;
 
 	rc = get_children_props(dn->parent, &indexes, &names, &types, &domains);
@@ -208,7 +208,7 @@ static int rpaphp_check_drc_props_v1(struct device_node *dn, char *drc_name,
 
 	/* Iterate through parent properties, looking for my-drc-index */
 	for (i = 0; i < be32_to_cpu(indexes[0]); i++) {
-		if ((unsigned int) indexes[i + 1] == my_index)
+		if (be32_to_cpu(indexes[i + 1]) == my_index)
 			break;
 
 		name_tmp += (strlen(name_tmp) + 1);
@@ -267,7 +267,7 @@ static int rpaphp_check_drc_props_v2(struct device_node *dn, char *drc_name,
 int rpaphp_check_drc_props(struct device_node *dn, char *drc_name,
 			char *drc_type)
 {
-	const unsigned int *my_index;
+	const __be32 *my_index;
 
 	my_index = of_get_property(dn, "ibm,my-drc-index", NULL);
 	if (!my_index) {
@@ -277,10 +277,10 @@ int rpaphp_check_drc_props(struct device_node *dn, char *drc_name,
 
 	if (of_find_property(dn->parent, "ibm,drc-info", NULL))
 		return rpaphp_check_drc_props_v2(dn, drc_name, drc_type,
-						*my_index);
+						be32_to_cpu(*my_index));
 	else
 		return rpaphp_check_drc_props_v1(dn, drc_name, drc_type,
-						*my_index);
+						be32_to_cpu(*my_index));
 }
 EXPORT_SYMBOL_GPL(rpaphp_check_drc_props);
 
@@ -311,10 +311,11 @@ static int is_php_type(char *drc_type)
  * for built-in pci slots (even when the built-in slots are
  * dlparable.)
  */
-static int is_php_dn(struct device_node *dn, const int **indexes,
-		const int **names, const int **types, const int **power_domains)
+static int is_php_dn(struct device_node *dn, const __be32 **indexes,
+		     const __be32 **names, const __be32 **types,
+		     const __be32 **power_domains)
 {
-	const int *drc_types;
+	const __be32 *drc_types;
 	int rc;
 
 	rc = get_children_props(dn, indexes, names, &drc_types, power_domains);
@@ -349,7 +350,7 @@ int rpaphp_add_slot(struct device_node *dn)
 	struct slot *slot;
 	int retval = 0;
 	int i;
-	const int *indexes, *names, *types, *power_domains;
+	const __be32 *indexes, *names, *types, *power_domains;
 	char *name, *type;
 
 	if (!dn->name || strcmp(dn->name, "pci"))
-- 
2.20.1




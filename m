Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2162B6404
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbgKQNoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732699AbgKQNmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 495A120729;
        Tue, 17 Nov 2020 13:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620521;
        bh=s0ADoaIuaqKSPMdXHLHeSk4jxNwWX+RpaAvPejzXCTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y86gabKoCrmsMxBqDtJcrZ6DyOjQYHVhycrcSfeK89s7S+8DEY6W7YdYNXbSI4wn1
         5xM3QelZ+MbOvcJkuPaofO4AH4TjqXhEk5sqel2FNQoIAZGsSSNfhm5iKuPWEecK/w
         ARcwQTuewSEJIUIZhOEs8a1DWkhIFmMoqD/QMb0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 247/255] devlink: Avoid overwriting port attributes of registered port
Date:   Tue, 17 Nov 2020 14:06:27 +0100
Message-Id: <20201117122150.953448390@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 9f73bd1c2c4c304b238051fc92b3f807326f0a89 ]

Cited commit in fixes tag overwrites the port attributes for the
registered port.

Avoid such error by checking registered flag before setting attributes.

Fixes: 71ad8d55f8e5 ("devlink: Replace devlink_port_attrs_set parameters with a struct")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20201111034744.35554-1-parav@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7675,8 +7675,6 @@ static int __devlink_port_attrs_set(stru
 {
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 
-	if (WARN_ON(devlink_port->registered))
-		return -EEXIST;
 	devlink_port->attrs_set = true;
 	attrs->flavour = flavour;
 	if (attrs->switch_id.id_len) {
@@ -7700,6 +7698,8 @@ void devlink_port_attrs_set(struct devli
 {
 	int ret;
 
+	if (WARN_ON(devlink_port->registered))
+		return;
 	devlink_port->attrs = *attrs;
 	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
 	if (ret)
@@ -7719,6 +7719,8 @@ void devlink_port_attrs_pci_pf_set(struc
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
+	if (WARN_ON(devlink_port->registered))
+		return;
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_PF);
 	if (ret)
@@ -7741,6 +7743,8 @@ void devlink_port_attrs_pci_vf_set(struc
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
+	if (WARN_ON(devlink_port->registered))
+		return;
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_VF);
 	if (ret)



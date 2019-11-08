Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9167FF5694
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732743AbfKHTJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387473AbfKHTJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBCDB21D7B;
        Fri,  8 Nov 2019 19:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240177;
        bh=GYcWA11AodRg7allrpKKPq/XjN8pRSeHNKS8rUMFDeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7zcLlooazoicRlB+ulPNEsBX53AECLyXPK14WcvTnsEssy9qhamvMiBJ+ScVlWWn
         iWWNuU05XaD8luQiXubCRzx9/IhyP3+pFxBdxHJ3cj3r2UPqgoeplyMhpvfWS1v/J4
         1IGoUeqcoQjclFiXqg8yC+TYx8EsboNveO07X9y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 113/140] net/mlx5: Fix flow counter list auto bits struct
Date:   Fri,  8 Nov 2019 19:50:41 +0100
Message-Id: <20191108174911.959486499@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit 6dfef396ea13873ae9066ee2e0ad6ee364031fe2 ]

The union should contain the extended dest and counter list.
Remove the resevered 0x40 bits which is redundant.
This change doesn't break any functionally.
Everything works today because the code in fs_cmd.c is using
the correct structs if extended dest or the basic dest.

Fixes: 1b115498598f ("net/mlx5: Introduce extended destination fields")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mlx5/mlx5_ifc.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1437,9 +1437,8 @@ struct mlx5_ifc_extended_dest_format_bit
 };
 
 union mlx5_ifc_dest_format_struct_flow_counter_list_auto_bits {
-	struct mlx5_ifc_dest_format_struct_bits dest_format_struct;
+	struct mlx5_ifc_extended_dest_format_bits extended_dest_format;
 	struct mlx5_ifc_flow_counter_list_bits flow_counter_list;
-	u8         reserved_at_0[0x40];
 };
 
 struct mlx5_ifc_fte_match_param_bits {



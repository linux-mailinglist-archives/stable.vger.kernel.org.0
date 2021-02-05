Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05F5311477
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhBEWGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232844AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F01064FE8;
        Fri,  5 Feb 2021 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534219;
        bh=LQFCfDTp9Mj36CDWD8S4ls7p/ay7TOVrvFHNGQczXJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCQFhVYnpWv2HnHCSYngK3f1Qj+Ci/e+F2p0o5wrHIRfF7ruTZD154DoXuADSfO2J
         3DyAfs6uPkh5vtrHo4Qn8980DMLnDaclVNLJB+CMucDjAghVeVCqRFHIQSg1nqVWau
         1n4R8cDFAZKR+oR8g/Bjt1cDdTrc8RfhRStWv7nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 06/57] mlxsw: spectrum_span: Do not overwrite policer configuration
Date:   Fri,  5 Feb 2021 15:06:32 +0100
Message-Id: <20210205140656.250429388@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit b6f6881aaf2344bf35a4221810737abe5fd210af upstream.

The purpose of the delayed work in the SPAN module is to potentially
update the destination port and various encapsulation parameters of SPAN
agents that point to a VLAN device or a GRE tap. The destination port
can change following the insertion of a new route, for example.

SPAN agents that point to a physical port or the CPU port are static and
never change throughout the lifetime of the SPAN agent. Therefore, skip
over them in the delayed work.

This fixes an issue where the delayed work overwrites the policer
that was set on a SPAN agent pointing to the CPU. Modifying the delayed
work to inherit the original policer configuration is error-prone, as
the same will be needed for any new parameter.

Fixes: 4039504e6a0c ("mlxsw: spectrum_span: Allow setting policer on a SPAN agent")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index c6c5826aba41..1892cea05ee7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -157,6 +157,7 @@ mlxsw_sp1_span_entry_cpu_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp1_span_entry_ops_cpu = {
+	.is_static = true,
 	.can_handle = mlxsw_sp1_span_cpu_can_handle,
 	.parms_set = mlxsw_sp1_span_entry_cpu_parms,
 	.configure = mlxsw_sp1_span_entry_cpu_configure,
@@ -214,6 +215,7 @@ mlxsw_sp_span_entry_phys_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp_span_entry_ops_phys = {
+	.is_static = true,
 	.can_handle = mlxsw_sp_port_dev_check,
 	.parms_set = mlxsw_sp_span_entry_phys_parms,
 	.configure = mlxsw_sp_span_entry_phys_configure,
@@ -721,6 +723,7 @@ mlxsw_sp2_span_entry_cpu_deconfigure(struct mlxsw_sp_span_entry *span_entry)
 
 static const
 struct mlxsw_sp_span_entry_ops mlxsw_sp2_span_entry_ops_cpu = {
+	.is_static = true,
 	.can_handle = mlxsw_sp2_span_cpu_can_handle,
 	.parms_set = mlxsw_sp2_span_entry_cpu_parms,
 	.configure = mlxsw_sp2_span_entry_cpu_configure,
@@ -1036,6 +1039,9 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work)
 		if (!refcount_read(&curr->ref_count))
 			continue;
 
+		if (curr->ops->is_static)
+			continue;
+
 		err = curr->ops->parms_set(mlxsw_sp, curr->to_dev, &sparms);
 		if (err)
 			continue;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index d907718bc8c5..aa1cd409c0e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -60,6 +60,7 @@ struct mlxsw_sp_span_entry {
 };
 
 struct mlxsw_sp_span_entry_ops {
+	bool is_static;
 	bool (*can_handle)(const struct net_device *to_dev);
 	int (*parms_set)(struct mlxsw_sp *mlxsw_sp,
 			 const struct net_device *to_dev,
-- 
2.30.0




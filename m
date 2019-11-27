Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16910BD8E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbfK0U4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731090AbfK0U4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08F8820862;
        Wed, 27 Nov 2019 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888209;
        bh=cI00S5SAfJJxJwKC2KRPKowU5ynXC6YjOEbMSMAB+Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyrnPneJy00HJ71Iu6b13a8CbzaKVDH+M3/gSRdboYGdLT42rUIKmJFfpEUMKHw4D
         hgKBlBM9DlzeYZIoHZjJ5KtyPVkrgudHZ5do2LrasewymVdx65v3v8fQx5zV6Q6sjw
         v/ZEnppeQwc6HpMjD0h5PRWXOaaP3QEbiBY5QdJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 009/306] net/mlxfw: Verify FSM error code translation doesnt exceed array size
Date:   Wed, 27 Nov 2019 21:27:39 +0100
Message-Id: <20191127203115.412098570@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

[ Upstream commit 30e9e0550bf693c94bc15827781fe42dd60be634 ]

Array mlxfw_fsm_state_err_str contains value to string translation, when
values are provided by mlxfw_dev. If value is larger than
MLXFW_FSM_STATE_ERR_MAX, return "unknown error" as expected instead of
reading an address than exceed array size.

Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash process")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -86,6 +86,8 @@ retry:
 		return err;
 
 	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
+		fsm_state_err = min_t(enum mlxfw_fsm_state_err,
+				      fsm_state_err, MLXFW_FSM_STATE_ERR_MAX);
 		pr_err("Firmware flash failed: %s\n",
 		       mlxfw_fsm_state_err_str[fsm_state_err]);
 		return -EINVAL;



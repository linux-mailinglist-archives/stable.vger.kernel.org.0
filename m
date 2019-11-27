Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3F410BC3E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbfK0VKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732979AbfK0VKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:10:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09C11215E5;
        Wed, 27 Nov 2019 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889006;
        bh=SqMW4hCcldfW2mDahIlh2I9tVtwkezDvEFTypsIIOdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxgKPebAQgD66ZGyC4fWP4bpu5TuO2/vZdj8aQysQOrRQiCDy2wHRKP/e2rTJMdjL
         a1rBYrRgDhAiww5a3Dko6SaoG83mwI1NJ8L81qdoMQcPQWoB5e9snNWIgNK+cbdn+h
         56ba7L7YHMHVWerIhylI6NV0VLagcqJwRxWKQ6rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 08/95] net/mlxfw: Verify FSM error code translation doesnt exceed array size
Date:   Wed, 27 Nov 2019 21:31:25 +0100
Message-Id: <20191127202849.812027680@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
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
@@ -66,6 +66,8 @@ retry:
 		return err;
 
 	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
+		fsm_state_err = min_t(enum mlxfw_fsm_state_err,
+				      fsm_state_err, MLXFW_FSM_STATE_ERR_MAX);
 		pr_err("Firmware flash failed: %s\n",
 		       mlxfw_fsm_state_err_str[fsm_state_err]);
 		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");



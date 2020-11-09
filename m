Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DA82AB92C
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgKINGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731111AbgKINGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:06:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3A3206B2;
        Mon,  9 Nov 2020 13:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927198;
        bh=Y+h7QsOu55ZB97VkRuEf0hf6PppXRgG7RLw3rou4IEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lciy+1GTzvrD6eYVp0oCdb0RNz+gkJGLVc2w3UINwp47ICvGzi5PyOLweYsac8CVP
         z8gJ+H01B1pTbuOwm7sSKrQCFzX7EQAMiN/4GQID5WwwEuesl76aR2SMkJmjulvfEt
         KjBLfhFSeUtUfLojhQBzI1pv3gyTDZrE499VA28M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Malat <oss@malat.biz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 07/48] sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms
Date:   Mon,  9 Nov 2020 13:55:16 +0100
Message-Id: <20201109125017.105494941@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Malat <oss@malat.biz>

[ Upstream commit b6df8c81412190fbd5eaa3cec7f642142d9c16cd ]

Commit 978aa0474115 ("sctp: fix some type cast warnings introduced since
very beginning")' broke err reading from sctp_arg, because it reads the
value as 32-bit integer, although the value is stored as 16-bit integer.
Later this value is passed to the userspace in 16-bit variable, thus the
user always gets 0 on big-endian platforms. Fix it by reading the __u16
field of sctp_arg union, as reading err field would produce a sparse
warning.

Fixes: 978aa0474115 ("sctp: fix some type cast warnings introduced since very beginning")
Signed-off-by: Petr Malat <oss@malat.biz>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/20201030132633.7045-1-oss@malat.biz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1591,12 +1591,12 @@ static int sctp_cmd_interpreter(enum sct
 			break;
 
 		case SCTP_CMD_INIT_FAILED:
-			sctp_cmd_init_failed(commands, asoc, cmd->obj.u32);
+			sctp_cmd_init_failed(commands, asoc, cmd->obj.u16);
 			break;
 
 		case SCTP_CMD_ASSOC_FAILED:
 			sctp_cmd_assoc_failed(commands, asoc, event_type,
-					      subtype, chunk, cmd->obj.u32);
+					      subtype, chunk, cmd->obj.u16);
 			break;
 
 		case SCTP_CMD_INIT_COUNTER_INC:



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DA72AB9BF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732486AbgKINMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731873AbgKINMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE01C2083B;
        Mon,  9 Nov 2020 13:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927533;
        bh=0QOxvSJhpAHWuVkKjKqImBorpm9ydfXg0rELIMh5bqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOTOiwVEy7Ene+3yZa7uOUDVbc8HydgoNaSHsQ0TJEDng05t3RuJndtebbT8ekqJu
         XjCINdPcrMcj+9OMi/YhLQbAO/VALwM+UWlFyfT5d2+Fya1p5rQ+980DpsXBzPRLSf
         w1QCxqxH3iiaB0e1ZcreigcW5vYGs/17QM2INLoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Malat <oss@malat.biz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 20/85] sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms
Date:   Mon,  9 Nov 2020 13:55:17 +0100
Message-Id: <20201109125023.555225859@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
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
@@ -1600,12 +1600,12 @@ static int sctp_cmd_interpreter(enum sct
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



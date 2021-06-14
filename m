Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D3B3A644F
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbhFNLWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236163AbhFNLUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:20:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C0E66199B;
        Mon, 14 Jun 2021 10:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667925;
        bh=KBxb1t3goWtNmD3rni4XEujE+0wOKA6n7awr95ykA+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYx59AT0b96pFhZ4aO4VwKUeeZutQhDGwNb1u1446Rp3Bwlv9hdTYqJhLW0nAtBCH
         VUu0EZKYrC0mhMRj/dL2s1wQZJfyW2l7M/3xbG2iIi9c83LCEE98QDndM4KYzDoLWC
         aove2B//5/zRPKTN5PE/id4MktYjrbuTehXm2sKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.12 127/173] usb: typec: tcpm: Fix misuses of AMS invocation
Date:   Mon, 14 Jun 2021 12:27:39 +0200
Message-Id: <20210614102702.396809002@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit 80137c18737c30d20ee630e442405236d96898a7 upstream.

tcpm_ams_start is used to initiate an AMS as well as checking Collision
Avoidance conditions but not for flagging passive AMS (initiated by the
port partner). Fix the misuses of tcpm_ams_start in tcpm_pd_svdm.

ATTENTION doesn't need responses so the AMS flag is not needed here.

Fixes: 0bc3ee92880d ("usb: typec: tcpm: Properly interrupt VDM AMS")
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210601123151.3441914-5-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1537,7 +1537,7 @@ static int tcpm_pd_svdm(struct tcpm_port
 				svdm_version = PD_VDO_SVDM_VER(p[0]);
 			}
 
-			tcpm_ams_start(port, DISCOVER_IDENTITY);
+			port->ams = DISCOVER_IDENTITY;
 			/*
 			 * PD2.0 Spec 6.10.3: respond with NAK as DFP (data host)
 			 * PD3.1 Spec 6.4.4.2.5.1: respond with NAK if "invalid field" or
@@ -1560,19 +1560,18 @@ static int tcpm_pd_svdm(struct tcpm_port
 			}
 			break;
 		case CMD_DISCOVER_SVID:
-			tcpm_ams_start(port, DISCOVER_SVIDS);
+			port->ams = DISCOVER_SVIDS;
 			break;
 		case CMD_DISCOVER_MODES:
-			tcpm_ams_start(port, DISCOVER_MODES);
+			port->ams = DISCOVER_MODES;
 			break;
 		case CMD_ENTER_MODE:
-			tcpm_ams_start(port, DFP_TO_UFP_ENTER_MODE);
+			port->ams = DFP_TO_UFP_ENTER_MODE;
 			break;
 		case CMD_EXIT_MODE:
-			tcpm_ams_start(port, DFP_TO_UFP_EXIT_MODE);
+			port->ams = DFP_TO_UFP_EXIT_MODE;
 			break;
 		case CMD_ATTENTION:
-			tcpm_ams_start(port, ATTENTION);
 			/* Attention command does not have response */
 			*adev_action = ADEV_ATTENTION;
 			return 0;



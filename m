Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21F26AF51F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbjCGTWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjCGTWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:22:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21845C0802
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:07:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96FEBB8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA54FC433EF;
        Tue,  7 Mar 2023 19:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216021;
        bh=Y4JlnfNnT8ib0B7uWkhvO5bKf+jE2kECZJYrm/omIY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mA8LlFthuHIETv8XaI1xe3Ss/Fmmv97DDO/IOXjJxMRpR38ELNMWE/+24T36OaESw
         ErNUe0/tfRFH7E6rfFA99Iqp+Q1MV+Vxe0Eu08gMkJQO/BPTZYoX7V9OG5btWrbolN
         eZPxzeGa4ZihXyNPQkJucRqqmML/QR+eaMMPL7nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 5.15 450/567] fs: dlm: dont set stop rx flag after node reset
Date:   Tue,  7 Mar 2023 18:03:06 +0100
Message-Id: <20230307165925.421181928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 15c63db8e86a72e0d5cfb9bf0cd1870e39a3e5fe upstream.

Similar to the stop tx flag, the rx flag should warn about a dlm message
being received at DLM_FIN state change, when we are assuming no other
dlm application messages. If we receive a FIN message and we are in the
state DLM_FIN_WAIT2 we call midcomms_node_reset() which puts the
midcomms node into DLM_CLOSED state. Afterwards we should not set the
DLM_NODE_FLAG_STOP_RX flag any more.  This patch changes the setting
DLM_NODE_FLAG_STOP_RX in those state changes when we receive a FIN
message and we assume there will be no other dlm application messages
received until we hit DLM_CLOSED state.

Cc: stable@vger.kernel.org
Fixes: 489d8e559c65 ("fs: dlm: add reliable connection if reconnect")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/midcomms.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -504,6 +504,7 @@ static void dlm_midcomms_receive_buffer(
 				break;
 			case DLM_FIN_WAIT1:
 				node->state = DLM_CLOSING;
+				set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
 				break;
@@ -524,8 +525,6 @@ static void dlm_midcomms_receive_buffer(
 				return;
 			}
 			spin_unlock(&node->state_lock);
-
-			set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 			break;
 		default:
 			WARN_ON(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));



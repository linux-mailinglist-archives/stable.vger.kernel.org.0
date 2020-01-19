Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A56141E95
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 15:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgASOis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 09:38:48 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50667 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgASOir (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 09:38:47 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3575021BF7;
        Sun, 19 Jan 2020 09:38:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 19 Jan 2020 09:38:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=T0WXDi
        lLvZ7n/HsVoMmjNF+ey8uOOZEipc6wWBYhfTo=; b=XsutI+g8PjhJFtn8/vtr/o
        VtpBiQJBebxK9xs3oV7plM09SpnK8OWAJOV0UZNtR4UFGuwV1g+s3YzKPwVz13MI
        i4QXopTk5hX0tMamvoKZTUeyBlBpx0DYzq21kpmFpjjSRVxRqtFBTnmXgZ4T+rfV
        NpIlzgYA0tZzj7mepK+Cs8KyAQCyun3xtgU1hWHraWY7xWrK9K6/N6Z6oln88U4W
        G/5GnmTGEQ1SJ+ltz9pIOFZQ1t16i1bRIikaksQ7N1cC0mnYjFgC0JrDe4fRuQbs
        3lV7NsWknDXurxyuDKRT/gBzJj4z20ShS/S9iZ5htBa1aJW2PSHnoU3vYe2hUjIQ
        ==
X-ME-Sender: <xms:92kkXs0hOD2LAp6IA8eGRps359547RKfjSQ540zVg3i3k3519xM01A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeegrddvgedurdduleejrdeijeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:92kkXhGB4IOSTFNT_W6NXa8X-lcFhBQuFyI23OzNxBxHa9vjo8lV-g>
    <xmx:92kkXu84CjcVo94X9XVGbTnZaz1Gxjr-IsJMiP7B4rbz8WFkVSfQOg>
    <xmx:92kkXnnNFnfjzQhmgLs_nwpLRKG-IdsfB7QhtLhkOBEPqQAKsLIeUw>
    <xmx:92kkXtZD9yLioMgkclvQiOuWsX43r1vN1lOklImblCQ00PhWi8rYmQ>
Received: from localhost (unknown [84.241.197.67])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E1473060AA0;
        Sun, 19 Jan 2020 09:38:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Reorder detect_edp_sink_caps before link" failed to apply to 5.4-stable tree
To:     mario.kleiner.de@gmail.com, alexander.deucher@amd.com,
        harry.wentland@amd.com, martin.leung@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 19 Jan 2020 15:38:44 +0100
Message-ID: <157944472417561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b7c59754cc22760760a84ebddb8e0b1e8dd871b Mon Sep 17 00:00:00 2001
From: Mario Kleiner <mario.kleiner.de@gmail.com>
Date: Thu, 9 Jan 2020 16:20:27 +0100
Subject: [PATCH] drm/amd/display: Reorder detect_edp_sink_caps before link
 settings read.

read_current_link_settings_on_detect() on eDP 1.4+ may use the
edp_supported_link_rates table which is set up by
detect_edp_sink_caps(), so that function needs to be called first.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Kleiner <mario.kleiner.de@gmail.com>
Cc: Martin Leung <martin.leung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 62d8289abb4e..4619f94f0ac7 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -817,8 +817,8 @@ static bool dc_link_detect_helper(struct dc_link *link,
 		}
 
 		case SIGNAL_TYPE_EDP: {
-			read_current_link_settings_on_detect(link);
 			detect_edp_sink_caps(link);
+			read_current_link_settings_on_detect(link);
 			sink_caps.transaction_type = DDC_TRANSACTION_TYPE_I2C_OVER_AUX;
 			sink_caps.signal = SIGNAL_TYPE_EDP;
 			break;


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C9214D891
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 11:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgA3KEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 05:04:20 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:60685 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbgA3KET (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 05:04:19 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 0CBD74A2;
        Thu, 30 Jan 2020 05:04:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 05:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YetnEX
        /TBt7asQouR2Gh6KOU/690DJASZcwlVO5+s1M=; b=Jit3nFNwGdOg4uuPf3HFvu
        eyIxvs120KxAA+YqfdmhEu1+zK4rGaHQbkV4T3FEOGX6hVxRSpysT+21UVQ7KFop
        RnLE5OAy4NFhTGUC9/EMFjnzIhHe8lCk2PtYA9L1VxfjA4aY4UU2DizvUo3WyZ3Y
        ASoqDhtIkZPSc2TkfVcu8aeHWmBs3kI3hO3rTVnIbb4eUIXOWBSMU/pWwc6bP7bd
        Xh6r9srFMOqlyYgI1/55TkzgCFC6pXbE8T1O45kTqnnSMGvSpXgWGTyA43Xel8Gg
        cePmsIPInYEl5F/3wWZAeuin35jMgGNU3OEwYqiVcfPS+EHHkkf8TBstjmRRBaFA
        ==
X-ME-Sender: <xms:IqoyXt200_NFhdKjxYuwqkoc_x0bfeQsW3xmvPIC0la8NFEWmSIFcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IqoyXrTVOSqp1UWiQK8pJNkAlk6eIE6IWOms5tq2Mm1L8GAafuaWlA>
    <xmx:IqoyXiSs7rLCtNvCWLEi7_RrErh5XGYCispg8xDItywhsRpk3rUD7A>
    <xmx:IqoyXjgN-qEX8XkVkzgYV2DpYd2ctEuTK_eZwqcMDylrA3Ns1x_Kaw>
    <xmx:IqoyXqMkP9npr6IMaKq7MRveBBnyhrwttTriba4aLAa03z1Z5uxrIQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 37C61328005E;
        Thu, 30 Jan 2020 05:04:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: turn off VBUS when leaving host mode" failed to apply to 4.4-stable tree
To:     b-liu@ti.com, balbi@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Jan 2020 11:04:15 +0100
Message-ID: <1580378655248113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 09ed259fac621634d51cd986aa8d65f035662658 Mon Sep 17 00:00:00 2001
From: Bin Liu <b-liu@ti.com>
Date: Wed, 11 Dec 2019 10:10:03 -0600
Subject: [PATCH] usb: dwc3: turn off VBUS when leaving host mode

VBUS should be turned off when leaving the host mode.
Set GCTL_PRTCAP to device mode in teardown to de-assert DRVVBUS pin to
turn off VBUS power.

Fixes: 5f94adfeed97 ("usb: dwc3: core: refactor mode initialization to its own function")
Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index f561c6c9e8a9..1d85c42b9c67 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1246,6 +1246,9 @@ static void dwc3_core_exit_mode(struct dwc3 *dwc)
 		/* do nothing */
 		break;
 	}
+
+	/* de-assert DRVVBUS for HOST and OTG mode */
+	dwc3_set_prtcap(dwc, DWC3_GCTL_PRTCAP_DEVICE);
 }
 
 static void dwc3_get_properties(struct dwc3 *dwc)


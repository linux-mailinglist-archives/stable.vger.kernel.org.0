Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A2033B871
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhCOODb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231688AbhCOOAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A96D64DAD;
        Mon, 15 Mar 2021 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816782;
        bh=198ZG1tjpE0eJK8e0iIWR6GPw4Ku9YEGd3F79jUu4mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVfeuiLLPuNhFTjFZzNZjjkgVwiUQfKWY87nLA1rNWRENYnUDWoOrlu+B+VWstdkZ
         MOqFRkEB5Z6hykk4b4NGGx/WAJgK/RAaZo6kToCvFbswy9SF9D0DAxufL2wEgvOFMQ
         qm455MIYO3lNalaTvh2ivTV6P2/YNlwWmHWft0Dc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruslan Bilovol <ruslan.bilovol@gmail.com>
Subject: [PATCH 5.4 106/168] usb: gadget: f_uac1: stop playback on function disable
Date:   Mon, 15 Mar 2021 14:55:38 +0100
Message-Id: <20210315135553.848590368@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ruslan Bilovol <ruslan.bilovol@gmail.com>

commit cc2ac63d4cf72104e0e7f58bb846121f0f51bb19 upstream.

There is missing playback stop/cleanup in case of
gadget's ->disable callback that happens on
events like USB host resetting or gadget disconnection

Fixes: 0591bc236015 ("usb: gadget: add f_uac1 variant based on a new u_audio api")
Cc: <stable@vger.kernel.org> # 4.13+
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/1614599375-8803-3-git-send-email-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -499,6 +499,7 @@ static void f_audio_disable(struct usb_f
 	uac1->as_out_alt = 0;
 	uac1->as_in_alt = 0;
 
+	u_audio_stop_playback(&uac1->g_audio);
 	u_audio_stop_capture(&uac1->g_audio);
 }
 



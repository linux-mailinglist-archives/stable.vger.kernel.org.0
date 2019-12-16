Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C81521215D9
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731827AbfLPSSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:18:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731679AbfLPSSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:18:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ECE620CC7;
        Mon, 16 Dec 2019 18:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520317;
        bh=Rj1qlk7stY5x9rTV5wv9WAaM/o0Wnz8SWBnZ/TGwgsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEKIU6iuEiO/FDk9DK5FenF9qh+qEMNpApIUX2qdYQjWcF0JCUZfNiVHE3wWsnkHt
         DcyDD8wdbs6bLFTXRIFsxS8VzJRmd0j80+wD/emkGjJfak+0GpW7KkdF4okYdQY444
         wgoppvYUsefXepbKVQMDLs2fuK72BecQx5sObu7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 105/177] cpuidle: teo: Ignore disabled idle states that are too deep
Date:   Mon, 16 Dec 2019 18:49:21 +0100
Message-Id: <20191216174841.455676852@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 069ce2ef1a6dd84cbd4d897b333e30f825e021f0 upstream.

Prevent disabled CPU idle state with target residencies beyond the
anticipated idle duration from being taken into account by the TEO
governor.

Fixes: b26bf6ab716f ("cpuidle: New timer events oriented governor for tickless systems")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.1+ <stable@vger.kernel.org> # 5.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/governors/teo.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -258,6 +258,13 @@ static int teo_select(struct cpuidle_dri
 
 		if (s->disabled || su->disable) {
 			/*
+			 * Ignore disabled states with target residencies beyond
+			 * the anticipated idle duration.
+			 */
+			if (s->target_residency > duration_us)
+				continue;
+
+			/*
 			 * If the "early hits" metric of a disabled state is
 			 * greater than the current maximum, it should be taken
 			 * into account, because it would be a mistake to select



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAD6178075
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732987AbgCCR5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732476AbgCCR4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:56:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8F4020728;
        Tue,  3 Mar 2020 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258215;
        bh=EymZWotPYr6FBHlO5nj0ypqTyji9ieLjSv7CM3vEsQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPP751jdISImQSBAp/0mjjshKgiE+Su8IyDHU07lJmr8upf7oLQ0zLV9uWUtb30TF
         0onHo7hsjeBZQFwDELelW9wG5wGD05G0utRW+leBj21Dsic8BO1txw6ZDZlvJCAr0P
         2RvqiwcSAN69oEgRWrpnJRwM1+2FK3iZ7NKJOOg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 5.4 115/152] kbuild: remove unneeded variable, single-all
Date:   Tue,  3 Mar 2020 18:43:33 +0100
Message-Id: <20200303174315.827055828@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 35e046a203ee3bc8ba9ae3561b50de02646dfb81 upstream.

When single-build is set, everything in $(MAKECMDGOALS) is a single
target. You can use $(MAKECMDGOALS) to list out the single targets.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1761,11 +1761,9 @@ tools/%: FORCE
 
 ifdef single-build
 
-single-all := $(filter $(single-targets), $(MAKECMDGOALS))
-
 # .ko is special because modpost is needed
-single-ko := $(sort $(filter %.ko, $(single-all)))
-single-no-ko := $(sort $(patsubst %.ko,%.mod, $(single-all)))
+single-ko := $(sort $(filter %.ko, $(MAKECMDGOALS)))
+single-no-ko := $(sort $(patsubst %.ko,%.mod, $(MAKECMDGOALS)))
 
 $(single-ko): single_modpost
 	@:



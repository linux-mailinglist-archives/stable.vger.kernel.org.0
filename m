Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9721AC93D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408766AbgDPPUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898643AbgDPNrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:47:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9024A21744;
        Thu, 16 Apr 2020 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044826;
        bh=57XLkEo9IUFW0ke8/XfWMYUe3XW5lyxCAG3v48t6+k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yU6WRZ6FKZCVPhAb4QdaAlsZ7J+3hfL2dNChN8UEoiP7gsrz8t0JnlyyAHo67D6m1
         pX5SK+q6k764oCkWKnBiZTELGbsaLYxF470gQEdDUMBen61ZqYHHSjXs2zWUnC0kJH
         7clYV/JoKrp3p90shJ7ui7vGW2YowISF9Ruo3lUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 116/232] PM / Domains: Allow no domain-idle-states DT property in genpd when parsing
Date:   Thu, 16 Apr 2020 15:23:30 +0200
Message-Id: <20200416131329.628923588@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit 56cb26891ea4180121265dc6b596015772c4a4b8 upstream.

Commit 2c361684803e ("PM / Domains: Don't treat zero found compatible idle
states as an error"), moved of_genpd_parse_idle_states() towards allowing
none compatible idle state to be found for the device node, rather than
returning an error code.

However, it didn't consider that the "domain-idle-states" DT property may
be missing as it's optional, which makes of_count_phandle_with_args() to
return -ENOENT. Let's fix this to make the behaviour consistent.

Fixes: 2c361684803e ("PM / Domains: Don't treat zero found compatible idle states as an error")
Reported-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2615,7 +2615,7 @@ static int genpd_iterate_idle_states(str
 
 	ret = of_count_phandle_with_args(dn, "domain-idle-states", NULL);
 	if (ret <= 0)
-		return ret;
+		return ret == -ENOENT ? 0 : ret;
 
 	/* Loop over the phandles until all the requested entry is found */
 	of_for_each_phandle(&it, ret, dn, "domain-idle-states", NULL, 0) {



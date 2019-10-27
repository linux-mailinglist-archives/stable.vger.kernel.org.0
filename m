Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E680E67F4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732833AbfJ0VZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732829AbfJ0VZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:57 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFBC821D80;
        Sun, 27 Oct 2019 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211557;
        bh=Eof4RQ75s/RksPlJ6cpa2YwMVmYN29cmy7xpvAAcZqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GV3CVZIo+2xgAEO5tTaHslDmsxhIeHK/ViAQWOclEpg0XaC9XgZmgAKVrzIRojJAx
         qu2UsR8XNZQlh7UrzbCLhso2R2jzWSAaD3CyT/lTXr+v6hKDBNY55tg+eOyYYqHuTZ
         tj12Vwf8Hq0OdJuVS0Wxdn+iuR1lCLKOmJSbH3ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.3 194/197] opp: of: drop incorrect lockdep_assert_held()
Date:   Sun, 27 Oct 2019 22:01:52 +0100
Message-Id: <20191027203406.961951101@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit f2edbb6699b0bc6e4f789846b99007200546c6c2 upstream.

_find_opp_of_np() doesn't traverse the list of OPP tables but instead
just the entries within an OPP table and so only requires to lock the
OPP table itself.

The lockdep_assert_held() was added there by mistake and isn't really
required.

Fixes: 5d6d106fa455 ("OPP: Populate required opp tables from "required-opps" property")
Cc: v5.0+ <stable@vger.kernel.org> # v5.0+
Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/opp/of.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -77,8 +77,6 @@ static struct dev_pm_opp *_find_opp_of_n
 {
 	struct dev_pm_opp *opp;
 
-	lockdep_assert_held(&opp_table_lock);
-
 	mutex_lock(&opp_table->lock);
 
 	list_for_each_entry(opp, &opp_table->opp_list, node) {



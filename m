Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5268724BC7C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgHTMrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729212AbgHTJp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C9D22D3E;
        Thu, 20 Aug 2020 09:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916688;
        bh=CB91mRZZtwRX5Rs6Z2McPo2ROvipo0Nrx6PjkXAUo9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUjnIdekwuKj0EslyrqzQXFaeeO9AtI2RuKFgaeCSiX+2o7/bu58rTOx4N9p2OeG6
         Iv20mW+ZaYFXBzUZkVciH+yGxM/cD9ACLTTuMWfdS7ww2SyntBLmEiDQF/ncy7ljjg
         4s3C6fwKPcodVLExs3SSvZ3SnTUEuF1q/o+gddx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 004/152] PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()
Date:   Thu, 20 Aug 2020 11:19:31 +0200
Message-Id: <20200820091553.844491744@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit dae68d7fd4930315389117e9da35b763f12238f9 upstream.

If context is not NULL in acpiphp_grab_context(), but the
is_going_away flag is set for the device's parent, the reference
counter of the context needs to be decremented before returning
NULL or the context will never be freed, so make that happen.

Fixes: edf5bf34d408 ("ACPI / dock: Use callback pointers from devices' ACPI hotplug contexts")
Reported-by: Vasily Averin <vvs@virtuozzo.com>
Cc: 3.15+ <stable@vger.kernel.org> # 3.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/acpiphp_glue.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -122,13 +122,21 @@ static struct acpiphp_context *acpiphp_g
 	struct acpiphp_context *context;
 
 	acpi_lock_hp_context();
+
 	context = acpiphp_get_context(adev);
-	if (!context || context->func.parent->is_going_away) {
-		acpi_unlock_hp_context();
-		return NULL;
+	if (!context)
+		goto unlock;
+
+	if (context->func.parent->is_going_away) {
+		acpiphp_put_context(context);
+		context = NULL;
+		goto unlock;
 	}
+
 	get_bridge(context->func.parent);
 	acpiphp_put_context(context);
+
+unlock:
 	acpi_unlock_hp_context();
 	return context;
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB8511B6B2
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbfLKQCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731378AbfLKPNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6790D24680;
        Wed, 11 Dec 2019 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077193;
        bh=etoHb+N2upRHCrg7AxpFPKl/JHHQbFBSU4cuwZv9h84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2hS8y4laDYzGqYrLV/88CRdmaB0niRQDue8ZxFYEbsRzh44Myqrs/LnTW1YfarEM
         5JLrTjAf9lqyf6QHoN925tuEYUrTzWydNgrEdAjqu0n3f/WJSa+0IG81uBCynP/E/4
         wNh4HfK9r/q0Vd8Rt1GIEy35tC9u/2McG4gRWf/w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 076/134] dt-bindings: Improve validation build error handling
Date:   Wed, 11 Dec 2019 10:10:52 -0500
Message-Id: <20191211151150.19073-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 93512dad334deb444619505f1fbb761156f7471b ]

Schema errors can cause make to exit before useful information is
printed. This leaves developers wondering what's wrong. It can be
overcome passing '-k' to make, but that's not an obvious solution.
There's 2 scenarios where this happens.

When using DT_SCHEMA_FILES to validate with a single schema, any error
in the schema results in processed-schema.yaml being empty causing a
make error. The result is the specific errors in the schema are never
shown because processed-schema.yaml is the first target built. Simply
making processed-schema.yaml last in extra-y ensures the full schema
validation with detailed error messages happen first.

The 2nd problem is while schema errors are ignored for
processed-schema.yaml, full validation of the schema still runs in
parallel and any schema validation errors will still stop the build when
running validation of dts files. The fix is to not add the schema
examples to extra-y in this case. This means 'dtbs_check' is no longer a
superset of 'dt_binding_check'. Update the documentation to make this
clear.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Tested-by: Jeffrey Hugo <jhugo@codeaurora.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/Makefile  | 5 ++++-
 Documentation/devicetree/writing-schema.rst | 6 ++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/Makefile b/Documentation/devicetree/bindings/Makefile
index 5138a2f6232aa..646cb35253733 100644
--- a/Documentation/devicetree/bindings/Makefile
+++ b/Documentation/devicetree/bindings/Makefile
@@ -12,7 +12,6 @@ $(obj)/%.example.dts: $(src)/%.yaml FORCE
 	$(call if_changed,chk_binding)
 
 DT_TMP_SCHEMA := processed-schema.yaml
-extra-y += $(DT_TMP_SCHEMA)
 
 quiet_cmd_mk_schema = SCHEMA  $@
       cmd_mk_schema = $(DT_MK_SCHEMA) $(DT_MK_SCHEMA_FLAGS) -o $@ $(real-prereqs)
@@ -26,8 +25,12 @@ DT_DOCS = $(shell \
 
 DT_SCHEMA_FILES ?= $(addprefix $(src)/,$(DT_DOCS))
 
+ifeq ($(CHECK_DTBS),)
 extra-y += $(patsubst $(src)/%.yaml,%.example.dts, $(DT_SCHEMA_FILES))
 extra-y += $(patsubst $(src)/%.yaml,%.example.dt.yaml, $(DT_SCHEMA_FILES))
+endif
 
 $(obj)/$(DT_TMP_SCHEMA): $(DT_SCHEMA_FILES) FORCE
 	$(call if_changed,mk_schema)
+
+extra-y += $(DT_TMP_SCHEMA)
diff --git a/Documentation/devicetree/writing-schema.rst b/Documentation/devicetree/writing-schema.rst
index f4a638072262f..83e04e5c342da 100644
--- a/Documentation/devicetree/writing-schema.rst
+++ b/Documentation/devicetree/writing-schema.rst
@@ -130,11 +130,13 @@ binding schema. All of the DT binding documents can be validated using the
 
     make dt_binding_check
 
-In order to perform validation of DT source files, use the `dtbs_check` target::
+In order to perform validation of DT source files, use the ``dtbs_check`` target::
 
     make dtbs_check
 
-This will first run the `dt_binding_check` which generates the processed schema.
+Note that ``dtbs_check`` will skip any binding schema files with errors. It is
+necessary to use ``dt_binding_check`` to get all the validation errors in the
+binding schema files.
 
 It is also possible to run checks with a single schema file by setting the
 ``DT_SCHEMA_FILES`` variable to a specific schema file.
-- 
2.20.1


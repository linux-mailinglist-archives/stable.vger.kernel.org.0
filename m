Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1AA63DE32
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiK3Sez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiK3Sed (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:34:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2AA93A4E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:34:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55ED661D67
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB00C433C1;
        Wed, 30 Nov 2022 18:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833271;
        bh=3UOwjTDYUDQ3TCyvgPsrN88pGMFuehV6ysYArYkVrIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J76F4nY+CziQwSlcgOzT7UcTEzyVmhWsIoVwzDLLMNrrlBD4S5jE9gSFGtACbepbl
         FBrMFa8eMlWoy2bvMAgaFqgBJSZlpdHmBU94+X9lu12O1VnDrFk0MOU7r3/6S2rnik
         MREEt+C9SylikTZQic8o3I/Q+/eZl2NHr2xzRZWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/206] speakup: Generate speakupmap.h automatically
Date:   Wed, 30 Nov 2022 19:21:12 +0100
Message-Id: <20221130180533.510548592@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit 6646b95aab5f62c049f1416a3801dec5432c348b ]

speakupmap.h was not actually intended to be source code, speakupmap.map
is.

This resurrects the makemapdata.c and genmap.c tools to generate
speakupmap.h automatically from the input and speakup headers, and the
speakupmap.map keyboard mapping source file.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/20220515230358.ikwt2kspiwvv5cf4@begin
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 92ca969ff881 ("speakup: replace utils' u_char with unsigned char")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accessibility/speakup/.gitignore    |   4 +
 drivers/accessibility/speakup/Makefile      |  28 ++++
 drivers/accessibility/speakup/genmap.c      | 162 ++++++++++++++++++++
 drivers/accessibility/speakup/makemapdata.c | 125 +++++++++++++++
 drivers/accessibility/speakup/speakupmap.h  |  66 --------
 drivers/accessibility/speakup/utils.h       | 102 ++++++++++++
 6 files changed, 421 insertions(+), 66 deletions(-)
 create mode 100644 drivers/accessibility/speakup/.gitignore
 create mode 100644 drivers/accessibility/speakup/genmap.c
 create mode 100644 drivers/accessibility/speakup/makemapdata.c
 delete mode 100644 drivers/accessibility/speakup/speakupmap.h
 create mode 100644 drivers/accessibility/speakup/utils.h

diff --git a/drivers/accessibility/speakup/.gitignore b/drivers/accessibility/speakup/.gitignore
new file mode 100644
index 000000000000..ac084679fea7
--- /dev/null
+++ b/drivers/accessibility/speakup/.gitignore
@@ -0,0 +1,4 @@
+/makemapdata
+/mapdata.h
+/genmap
+/speakupmap.h
diff --git a/drivers/accessibility/speakup/Makefile b/drivers/accessibility/speakup/Makefile
index 6e4bfac8af65..ba69b0803d42 100644
--- a/drivers/accessibility/speakup/Makefile
+++ b/drivers/accessibility/speakup/Makefile
@@ -30,3 +30,31 @@ speakup-y := \
 	thread.o \
 	varhandlers.o
 speakup-$(CONFIG_SPEAKUP_SERIALIO) += serialio.o
+
+
+clean-files := mapdata.h speakupmap.h
+
+
+# Generate mapdata.h from headers
+hostprogs += makemapdata
+makemapdata-objs := makemapdata.o
+
+quiet_cmd_mkmap = MKMAP   $@
+      cmd_mkmap = TOPDIR=$(srctree) $(obj)/makemapdata > $@
+
+$(obj)/mapdata.h: $(obj)/makemapdata
+	$(call cmd,mkmap)
+
+
+# Generate speakupmap.h from mapdata.h
+hostprogs += genmap
+genmap-objs := genmap.o
+$(obj)/genmap.o: $(obj)/mapdata.h
+
+quiet_cmd_genmap = GENMAP  $@
+      cmd_genmap = $(obj)/genmap $< > $@
+
+$(obj)/speakupmap.h: $(src)/speakupmap.map $(obj)/genmap
+	$(call cmd,genmap)
+
+$(obj)/main.o: $(obj)/speakupmap.h
diff --git a/drivers/accessibility/speakup/genmap.c b/drivers/accessibility/speakup/genmap.c
new file mode 100644
index 000000000000..0125000e00d9
--- /dev/null
+++ b/drivers/accessibility/speakup/genmap.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* genmap.c
+ * originally written by: Kirk Reiser.
+ *
+ ** Copyright (C) 2002  Kirk Reiser.
+ *  Copyright (C) 2003  David Borowski.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <libgen.h>
+#include <string.h>
+#include <linux/version.h>
+#include <ctype.h>
+#include "utils.h"
+
+struct st_key_init {
+	char *name;
+	int value, shift;
+};
+
+static unsigned char key_data[MAXKEYVAL][16], *kp;
+
+#include "mapdata.h"
+
+static const char delims[] = "\t\n ";
+static char *cp;
+static int map_ver = 119; /* an arbitrary number so speakup can check */
+static int shift_table[17];
+static int max_states = 1, flags;
+/* flags reserved for later, maybe for individual console maps */
+
+static int get_shift_value(int state)
+{
+	int i;
+
+	for (i = 0; shift_table[i] != state; i++) {
+		if (shift_table[i] == -1) {
+			if (i >= 16)
+				oops("too many shift states", NULL);
+			shift_table[i] = state;
+			max_states = i+1;
+		break;
+	}
+	}
+	return i;
+}
+
+int
+main(int argc, char *argv[])
+{
+	int value, shift_state, i, spk_val = 0, lock_val = 0;
+	int max_key_used = 0, num_keys_used = 0;
+	struct st_key *this;
+	struct st_key_init *p_init;
+	char buffer[256];
+
+	bzero(key_table, sizeof(key_table));
+	bzero(key_data, sizeof(key_data));
+
+	shift_table[0] = 0;
+	for (i = 1; i <= 16; i++)
+		shift_table[i] = -1;
+
+	if (argc < 2) {
+		fputs("usage: genmap filename\n", stderr);
+		exit(1);
+	}
+
+	for (p_init = init_key_data; p_init->name[0] != '.'; p_init++)
+		add_key(p_init->name, p_init->value, p_init->shift);
+
+	open_input(NULL, argv[1]);
+	while (fgets(buffer, sizeof(buffer), infile)) {
+		lc++;
+		value = shift_state = 0;
+
+		cp = strtok(buffer, delims);
+		if (*cp == '#')
+			continue;
+
+		while (cp) {
+			if (*cp == '=')
+				break;
+			this = find_key(cp);
+			if (this == NULL)
+				oops("unknown key/modifier", cp);
+			if (this->shift == is_shift) {
+				if (value)
+					oops("modifiers must come first", cp);
+				shift_state += this->value;
+			} else if (this->shift == is_input)
+				value = this->value;
+			else
+				oops("bad modifier or key", cp);
+			cp = strtok(0, delims);
+		}
+		if (!cp)
+			oops("no = found", NULL);
+
+		cp = strtok(0, delims);
+		if (!cp)
+			oops("no speakup function after =", NULL);
+
+		this = find_key(cp);
+		if (this == NULL || this->shift != is_spk)
+			oops("invalid speakup function", cp);
+
+		i = get_shift_value(shift_state);
+		if (key_data[value][i]) {
+			while (--cp > buffer)
+				if (!*cp)
+					*cp = ' ';
+			oops("two functions on same key combination", cp);
+		}
+		key_data[value][i] = (char)this->value;
+		if (value > max_key_used)
+			max_key_used = value;
+	}
+	fclose(infile);
+
+	this = find_key("spk_key");
+	if (this)
+		spk_val = this->value;
+
+	this = find_key("spk_lock");
+	if (this)
+		lock_val = this->value;
+
+	for (lc = 1; lc <= max_key_used; lc++) {
+		kp = key_data[lc];
+		if (!memcmp(key_data[0], kp, 16))
+			continue;
+		num_keys_used++;
+		for (i = 0; i < max_states; i++) {
+			if (kp[i] != spk_val && kp[i] != lock_val)
+				continue;
+			shift_state = shift_table[i];
+			if (shift_state&16)
+				continue;
+			shift_state = get_shift_value(shift_state+16);
+			kp[shift_state] = kp[i];
+			/* fill in so we can process the key up, as spk bit will be set */
+		}
+	}
+
+	printf("\t%d, %d, %d,\n\t", map_ver, num_keys_used, max_states);
+	for (i = 0; i < max_states; i++)
+		printf("%d, ", shift_table[i]);
+	printf("%d,", flags);
+	for (lc = 1; lc <= max_key_used; lc++) {
+		kp = key_data[lc];
+		if (!memcmp(key_data[0], kp, 16))
+			continue;
+		printf("\n\t%d,", lc);
+		for (i = 0; i < max_states; i++)
+			printf(" %d,", (unsigned int)kp[i]);
+	}
+	printf("\n\t0, %d\n", map_ver);
+
+	exit(0);
+}
diff --git a/drivers/accessibility/speakup/makemapdata.c b/drivers/accessibility/speakup/makemapdata.c
new file mode 100644
index 000000000000..81db9ebf1fff
--- /dev/null
+++ b/drivers/accessibility/speakup/makemapdata.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* makemapdata.c
+ * originally written by: Kirk Reiser.
+ *
+ ** Copyright (C) 2002  Kirk Reiser.
+ *  Copyright (C) 2003  David Borowski.
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <libgen.h>
+#include <string.h>
+#include <linux/version.h>
+#include <ctype.h>
+#include "utils.h"
+
+static char buffer[256];
+
+static int get_define(void)
+{
+	char *c;
+
+	while (fgets(buffer, sizeof(buffer)-1, infile)) {
+		lc++;
+		if (strncmp(buffer, "#define", 7))
+			continue;
+		c = buffer + 7;
+		while (*c == ' ' || *c == '\t')
+			c++;
+		def_name = c;
+		while (*c && *c != ' ' && *c != '\t' && *c != '\n')
+			c++;
+		if (!*c || *c == '\n')
+			continue;
+		*c++ = '\0';
+		while (*c == ' ' || *c == '\t' || *c == '(')
+			c++;
+		def_val = c;
+		while (*c && *c != '\n' && *c != ')')
+			c++;
+		*c++ = '\0';
+		return 1;
+	}
+	fclose(infile);
+	infile = 0;
+	return 0;
+}
+
+int
+main(int argc, char *argv[])
+{
+	int value, i;
+	struct st_key *this;
+	const char *dir_name;
+	char *cp;
+
+	dir_name = getenv("TOPDIR");
+	if (!dir_name)
+		dir_name = ".";
+	bzero(key_table, sizeof(key_table));
+	add_key("shift",	1, is_shift);
+	add_key("altgr",	2, is_shift);
+	add_key("ctrl",	4, is_shift);
+	add_key("alt",	8, is_shift);
+	add_key("spk", 16, is_shift);
+	add_key("double", 32, is_shift);
+
+	open_input(dir_name, "include/linux/input.h");
+	while (get_define()) {
+		if (strncmp(def_name, "KEY_", 4))
+			continue;
+		value = atoi(def_val);
+		if (value > 0 && value < MAXKEYVAL)
+			add_key(def_name, value, is_input);
+	}
+
+	open_input(dir_name, "include/uapi/linux/input-event-codes.h");
+	while (get_define()) {
+		if (strncmp(def_name, "KEY_", 4))
+			continue;
+		value = atoi(def_val);
+		if (value > 0 && value < MAXKEYVAL)
+			add_key(def_name, value, is_input);
+	}
+
+	open_input(dir_name, "drivers/accessibility/speakup/spk_priv_keyinfo.h");
+	while (get_define()) {
+		if (strlen(def_val) > 5) {
+			//if (def_val[0] == '(')
+			//	def_val++;
+			cp = strchr(def_val, '+');
+			if (!cp)
+				continue;
+			if (cp[-1] == ' ')
+				cp[-1] = '\0';
+			*cp++ = '\0';
+			this = find_key(def_val);
+			while (*cp == ' ')
+				cp++;
+			if (!this || *cp < '0' || *cp > '9')
+				continue;
+			value = this->value+atoi(cp);
+		} else if (!strncmp(def_val, "0x", 2))
+			sscanf(def_val+2, "%x", &value);
+		else if (*def_val >= '0' && *def_val <= '9')
+			value = atoi(def_val);
+		else
+			continue;
+		add_key(def_name, value, is_spk);
+	}
+
+	printf("struct st_key_init init_key_data[] = {\n");
+	for (i = 0; i < HASHSIZE; i++) {
+		this = &key_table[i];
+		if (!this->name)
+			continue;
+		do {
+			printf("\t{ \"%s\", %d, %d, },\n", this->name, this->value, this->shift);
+			this = this->next;
+		} while (this);
+	}
+	printf("\t{ \".\", 0, 0 }\n};\n");
+
+	exit(0);
+}
diff --git a/drivers/accessibility/speakup/speakupmap.h b/drivers/accessibility/speakup/speakupmap.h
deleted file mode 100644
index c60d7339b89a..000000000000
--- a/drivers/accessibility/speakup/speakupmap.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-	119, 62, 6,
-	0, 16, 20, 17, 32, 48, 0,
-	2, 0, 78, 0, 0, 0, 0,
-	3, 0, 79, 0, 0, 0, 0,
-	4, 0, 76, 0, 0, 0, 0,
-	5, 0, 77, 0, 0, 0, 0,
-	6, 0, 74, 0, 0, 0, 0,
-	7, 0, 75, 0, 0, 0, 0,
-	9, 0, 5, 46, 0, 0, 0,
-	10, 0, 4, 0, 0, 0, 0,
-	11, 0, 0, 1, 0, 0, 0,
-	12, 0, 27, 0, 33, 0, 0,
-	19, 0, 47, 0, 0, 0, 0,
-	21, 0, 29, 17, 0, 0, 0,
-	22, 0, 15, 0, 0, 0, 0,
-	23, 0, 14, 0, 0, 0, 28,
-	24, 0, 16, 0, 0, 0, 0,
-	25, 0, 30, 18, 0, 0, 0,
-	28, 0, 3, 26, 0, 0, 0,
-	35, 0, 31, 0, 0, 0, 0,
-	36, 0, 12, 0, 0, 0, 0,
-	37, 0, 11, 0, 0, 0, 22,
-	38, 0, 13, 0, 0, 0, 0,
-	39, 0, 32, 7, 0, 0, 0,
-	40, 0, 23, 0, 0, 0, 0,
-	44, 0, 44, 0, 0, 0, 0,
-	49, 0, 24, 0, 0, 0, 0,
-	50, 0, 9, 19, 6, 0, 0,
-	51, 0, 8, 0, 0, 0, 36,
-	52, 0, 10, 20, 0, 0, 0,
-	53, 0, 25, 0, 0, 0, 0,
-	55, 46, 1, 0, 0, 0, 0,
-	58, 128, 128, 0, 0, 0, 0,
-	59, 0, 45, 0, 0, 0, 0,
-	60, 0, 40, 0, 0, 0, 0,
-	61, 0, 41, 0, 0, 0, 0,
-	62, 0, 42, 0, 0, 0, 0,
-	63, 0, 34, 0, 0, 0, 0,
-	64, 0, 35, 0, 0, 0, 0,
-	65, 0, 37, 0, 0, 0, 0,
-	66, 0, 38, 0, 0, 0, 0,
-	67, 0, 66, 0, 39, 0, 0,
-	68, 0, 67, 0, 0, 0, 0,
-	71, 15, 19, 0, 0, 0, 0,
-	72, 14, 29, 0, 0, 28, 0,
-	73, 16, 17, 0, 0, 0, 0,
-	74, 27, 33, 0, 0, 0, 0,
-	75, 12, 31, 0, 0, 0, 0,
-	76, 11, 21, 0, 0, 22, 0,
-	77, 13, 32, 0, 0, 0, 0,
-	78, 23, 43, 0, 0, 0, 0,
-	79, 9, 20, 0, 0, 0, 0,
-	80, 8, 30, 0, 0, 36, 0,
-	81, 10, 18, 0, 0, 0, 0,
-	82, 128, 128, 0, 0, 0, 0,
-	83, 24, 25, 0, 0, 0, 0,
-	87, 0, 68, 0, 0, 0, 0,
-	88, 0, 69, 0, 0, 0, 0,
-	96, 3, 26, 0, 0, 0, 0,
-	98, 4, 5, 0, 0, 0, 0,
-	99, 2, 0, 0, 0, 0, 0,
-	104, 0, 6, 0, 0, 0, 0,
-	109, 0, 7, 0, 0, 0, 0,
-	125, 128, 128, 0, 0, 0, 0,
-	0, 119
diff --git a/drivers/accessibility/speakup/utils.h b/drivers/accessibility/speakup/utils.h
new file mode 100644
index 000000000000..4bf2ee8ac246
--- /dev/null
+++ b/drivers/accessibility/speakup/utils.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/* utils.h
+ * originally written by: Kirk Reiser.
+ *
+ ** Copyright (C) 2002  Kirk Reiser.
+ *  Copyright (C) 2003  David Borowski.
+ */
+
+#include <stdio.h>
+
+#define MAXKEYS 512
+#define MAXKEYVAL 160
+#define HASHSIZE 101
+#define is_shift -3
+#define is_spk -2
+#define is_input -1
+
+struct st_key {
+	char *name;
+	struct st_key *next;
+	int value, shift;
+};
+
+struct st_key key_table[MAXKEYS];
+struct st_key *extra_keys = key_table+HASHSIZE;
+char *def_name, *def_val;
+FILE *infile;
+int lc;
+
+char filename[256];
+
+static inline void open_input(const char *dir_name, const char *name)
+{
+	if (dir_name)
+		snprintf(filename, sizeof(filename), "%s/%s", dir_name, name);
+	else
+		snprintf(filename, sizeof(filename), "%s", name);
+	infile = fopen(filename, "r");
+	if (infile == 0) {
+		fprintf(stderr, "can't open %s\n", filename);
+		exit(1);
+	}
+	lc = 0;
+}
+
+static inline int oops(const char *msg, const char *info)
+{
+	if (info == NULL)
+		info = "";
+	fprintf(stderr, "error: file %s line %d\n", filename, lc);
+	fprintf(stderr, "%s %s\n", msg, info);
+	exit(1);
+}
+
+static inline struct st_key *hash_name(char *name)
+{
+	u_char *pn = (u_char *)name;
+	int hash = 0;
+
+	while (*pn) {
+		hash = (hash * 17) & 0xfffffff;
+		if (isupper(*pn))
+			*pn = tolower(*pn);
+		hash += (int)*pn;
+		pn++;
+	}
+	hash %= HASHSIZE;
+	return &key_table[hash];
+}
+
+static inline struct st_key *find_key(char *name)
+{
+	struct st_key *this = hash_name(name);
+
+	while (this) {
+		if (this->name && !strcmp(name, this->name))
+			return this;
+		this = this->next;
+	}
+	return this;
+}
+
+static inline struct st_key *add_key(char *name, int value, int shift)
+{
+	struct st_key *this = hash_name(name);
+
+	if (extra_keys-key_table >= MAXKEYS)
+		oops("out of key table space, enlarge MAXKEYS", NULL);
+	if (this->name != NULL) {
+		while (this->next) {
+			if (!strcmp(name, this->name))
+				oops("attempt to add duplicate key", name);
+			this = this->next;
+		}
+		this->next = extra_keys++;
+		this = this->next;
+	}
+	this->name = strdup(name);
+	this->value = value;
+	this->shift = shift;
+	return this;
+}
-- 
2.35.1




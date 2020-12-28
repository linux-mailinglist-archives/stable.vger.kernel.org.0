Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849822E3FCB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503088AbgL1OYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503084AbgL1OYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B0B2207B2;
        Mon, 28 Dec 2020 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165432;
        bh=JevaJKgB0OQZVfFrtoZeKjvd2DOI6bStpsdjPtf2Kkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r33Qd8Jpxpfv7vEFanBDAl4+Mm7649uCA/WlhY6i/tQwRkbsMfdvqmHKeplnW15tY
         fZefDBAD0fN1Fpig/8PYfcjeQh/4pw8lLdu7PmfgGDWLyly0uGxVt1qtsSL+Evj67b
         td3QEI0lSRT9e4fQfBSp9RtGr9ADYJthEovvI8Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 529/717] Input: cyapa_gen6 - fix out-of-bounds stack access
Date:   Mon, 28 Dec 2020 13:48:47 +0100
Message-Id: <20201228125046.313733217@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f051ae4f6c732c231046945b36234e977f8467c6 upstream.

gcc -Warray-bounds warns about a serious bug in
cyapa_pip_retrieve_data_structure:

drivers/input/mouse/cyapa_gen6.c: In function 'cyapa_pip_retrieve_data_structure.constprop':
include/linux/unaligned/access_ok.h:40:17: warning: array subscript -1 is outside array bounds of 'struct retrieve_data_struct_cmd[1]' [-Warray-bounds]
   40 |  *((__le16 *)p) = cpu_to_le16(val);
drivers/input/mouse/cyapa_gen6.c:569:13: note: while referencing 'cmd'
  569 |  } __packed cmd;
      |             ^~~

Apparently the '-2' was added to the pointer instead of the value,
writing garbage into the stack next to this variable.

Fixes: c2c06c41f700 ("Input: cyapa - add gen6 device module support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20201026161332.3708389-1-arnd@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/cyapa_gen6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/cyapa_gen6.c
+++ b/drivers/input/mouse/cyapa_gen6.c
@@ -573,7 +573,7 @@ static int cyapa_pip_retrieve_data_struc
 
 	memset(&cmd, 0, sizeof(cmd));
 	put_unaligned_le16(PIP_OUTPUT_REPORT_ADDR, &cmd.head.addr);
-	put_unaligned_le16(sizeof(cmd), &cmd.head.length - 2);
+	put_unaligned_le16(sizeof(cmd) - 2, &cmd.head.length);
 	cmd.head.report_id = PIP_APP_CMD_REPORT_ID;
 	cmd.head.cmd_code = PIP_RETRIEVE_DATA_STRUCTURE;
 	put_unaligned_le16(read_offset, &cmd.read_offset);



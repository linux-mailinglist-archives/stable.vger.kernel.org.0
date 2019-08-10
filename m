Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9388E46
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfHJUxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:53:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53880 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-00053r-8E; Sat, 10 Aug 2019 21:43:46 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-0003aF-Fl; Sat, 10 Aug 2019 21:43:45 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Colin Ian King" <colin.king@canonical.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.92622742@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 035/157] staging: rtl8712: uninitialized memory in
 read_bbreg_hdl()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 22c971db7dd4b0ad8dd88e99c407f7a1f4231a2e upstream.

Colin King reported a bug in read_bbreg_hdl():

	memcpy(pcmd->rsp, (u8 *)&val, pcmd->rspsz);

The problem is that "val" is uninitialized.

This code is obviously not useful, but so far as I can tell
"pcmd->cmdcode" is never GEN_CMD_CODE(_Read_BBREG) so it's not harmful
either.  For now the easiest fix is to just call r8712_free_cmd_obj()
and return.

Fixes: 2865d42c78a9 ("staging: r8712u: Add the new driver to the mainline kernel")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rtl8712/rtl8712_cmd.c | 10 +---------
 drivers/staging/rtl8712/rtl8712_cmd.h |  2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -155,19 +155,11 @@ static u8 write_macreg_hdl(struct _adapt
 
 static u8 read_bbreg_hdl(struct _adapter *padapter, u8 *pbuf)
 {
-	u32 val;
-	void (*pcmd_callback)(struct _adapter *dev, struct cmd_obj	*pcmd);
 	struct readBB_parm *prdbbparm;
 	struct cmd_obj *pcmd  = (struct cmd_obj *)pbuf;
 
 	prdbbparm = (struct readBB_parm *)pcmd->parmbuf;
-	if (pcmd->rsp && pcmd->rspsz > 0)
-		memcpy(pcmd->rsp, (u8 *)&val, pcmd->rspsz);
-	pcmd_callback = cmd_callback[pcmd->cmdcode].callback;
-	if (pcmd_callback == NULL)
-		r8712_free_cmd_obj(pcmd);
-	else
-		pcmd_callback(padapter, pcmd);
+	r8712_free_cmd_obj(pcmd);
 	return H2C_SUCCESS;
 }
 
--- a/drivers/staging/rtl8712/rtl8712_cmd.h
+++ b/drivers/staging/rtl8712/rtl8712_cmd.h
@@ -152,7 +152,7 @@ enum rtl8712_h2c_cmd {
 static struct _cmd_callback	cmd_callback[] = {
 	{GEN_CMD_CODE(_Read_MACREG), NULL}, /*0*/
 	{GEN_CMD_CODE(_Write_MACREG), NULL},
-	{GEN_CMD_CODE(_Read_BBREG), &r8712_getbbrfreg_cmdrsp_callback},
+	{GEN_CMD_CODE(_Read_BBREG), NULL},
 	{GEN_CMD_CODE(_Write_BBREG), NULL},
 	{GEN_CMD_CODE(_Read_RFREG), &r8712_getbbrfreg_cmdrsp_callback},
 	{GEN_CMD_CODE(_Write_RFREG), NULL}, /*5*/


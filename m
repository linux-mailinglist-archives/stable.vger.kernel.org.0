Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B446D49EE
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbjDCOmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbjDCOmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:42:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14961825B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D47CB81D07
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F00C4339B;
        Mon,  3 Apr 2023 14:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532930;
        bh=/UtXTKxPWee9amjyNtxBjonY+3putMhVxhd1K7Ksd2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cr26O2vTqlKYp3SHjljamBqGgFfHSkCqgMG+/8t6emVmaKmTWBq6VrZk8yWH3I1bm
         dNcI5LKjzHhQZUtmm4MnmfVw1xPgl9WdAuXbMrPJo9mjFg0oM+bNGsHUPSTxPQN1ww
         pEwHdwIhEahq9fRMFJ9b0ZgdzprN0hwDP5ZcE+FA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 6.1 171/181] net: dsa: mv88e6xxx: read FID when handling ATU violations
Date:   Mon,  3 Apr 2023 16:10:06 +0200
Message-Id: <20230403140420.690425716@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans J. Schultz <netdev@kapio-technology.com>

commit 4bf24ad09bc0b05e97fb48b962b2c9246fc76727 upstream.

When an ATU violation occurs, the switch uses the ATU FID register to
report the FID of the MAC address that incurred the violation. It would
be good for the driver to know the FID value for purposes such as
logging and CPU-based authentication.

Up until now, the driver has been calling the mv88e6xxx_g1_atu_op()
function to read ATU violations, but that doesn't do exactly what we
want, namely it calls mv88e6xxx_g1_atu_fid_write() with FID 0.
(side note, the documentation for the ATU Get/Clear Violation command
says that writes to the ATU FID register have no effect before the
operation starts, it's only that we disregard the value that this
register provides once the operation completes)

So mv88e6xxx_g1_atu_fid_write() is not what we want, but rather
mv88e6xxx_g1_atu_fid_read(). However, the latter doesn't exist, we need
to write it.

The remainder of mv88e6xxx_g1_atu_op() except for
mv88e6xxx_g1_atu_fid_write() is still needed, namely to send a
GET_CLR_VIOLATION command to the ATU. In principle we could have still
kept calling mv88e6xxx_g1_atu_op(), but the MDIO writes to the ATU FID
register are pointless, but in the interest of doing less CPU work per
interrupt, write a new function called mv88e6xxx_g1_read_atu_violation()
and call it.

The FID will be the port default FID as set by mv88e6xxx_port_set_fid()
if the VID from the packet cannot be found in the VTU. Otherwise it is
the FID derived from the VTU entry associated with that VID.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c |   72 +++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 11 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -114,6 +114,19 @@ static int mv88e6xxx_g1_atu_op_wait(stru
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_ATU_OP, bit, 0);
 }
 
+static int mv88e6xxx_g1_read_atu_violation(struct mv88e6xxx_chip *chip)
+{
+	int err;
+
+	err = mv88e6xxx_g1_write(chip, MV88E6XXX_G1_ATU_OP,
+				 MV88E6XXX_G1_ATU_OP_BUSY |
+				 MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	if (err)
+		return err;
+
+	return mv88e6xxx_g1_atu_op_wait(chip);
+}
+
 static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
 {
 	u16 val;
@@ -159,6 +172,41 @@ int mv88e6xxx_g1_atu_get_next(struct mv8
 	return mv88e6xxx_g1_atu_op(chip, fid, MV88E6XXX_G1_ATU_OP_GET_NEXT_DB);
 }
 
+static int mv88e6xxx_g1_atu_fid_read(struct mv88e6xxx_chip *chip, u16 *fid)
+{
+	u16 val = 0, upper = 0, op = 0;
+	int err = -EOPNOTSUPP;
+
+	if (mv88e6xxx_num_databases(chip) > 256) {
+		err = mv88e6xxx_g1_read(chip, MV88E6352_G1_ATU_FID, &val);
+		val &= 0xfff;
+		if (err)
+			return err;
+	} else {
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &op);
+		if (err)
+			return err;
+		if (mv88e6xxx_num_databases(chip) > 64) {
+			/* ATU DBNum[7:4] are located in ATU Control 15:12 */
+			err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_CTL,
+						&upper);
+			if (err)
+				return err;
+
+			upper = (upper >> 8) & 0x00f0;
+		} else if (mv88e6xxx_num_databases(chip) > 16) {
+			/* ATU DBNum[5:4] are located in ATU Operation 9:8 */
+			upper = (op >> 4) & 0x30;
+		}
+
+		/* ATU DBNum[3:0] are located in ATU Operation 3:0 */
+		val = (op & 0xf) | upper;
+	}
+	*fid = val;
+
+	return err;
+}
+
 /* Offset 0x0C: ATU Data Register */
 
 static int mv88e6xxx_g1_atu_data_read(struct mv88e6xxx_chip *chip,
@@ -353,14 +401,12 @@ static irqreturn_t mv88e6xxx_g1_atu_prob
 {
 	struct mv88e6xxx_chip *chip = dev_id;
 	struct mv88e6xxx_atu_entry entry;
-	int spid;
-	int err;
-	u16 val;
+	int err, spid;
+	u16 val, fid;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_g1_atu_op(chip, 0,
-				  MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
+	err = mv88e6xxx_g1_read_atu_violation(chip);
 	if (err)
 		goto out;
 
@@ -368,6 +414,10 @@ static irqreturn_t mv88e6xxx_g1_atu_prob
 	if (err)
 		goto out;
 
+	err = mv88e6xxx_g1_atu_fid_read(chip, &fid);
+	if (err)
+		goto out;
+
 	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
 	if (err)
 		goto out;
@@ -386,22 +436,22 @@ static irqreturn_t mv88e6xxx_g1_atu_prob
 
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU member violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU member violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_member_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_MISS_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU miss violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU miss violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_miss_violation++;
 	}
 
 	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
-				    "ATU full violation for %pM portvec %x spid %d\n",
-				    entry.mac, entry.portvec, spid);
+				    "ATU full violation for %pM fid %u portvec %x spid %d\n",
+				    entry.mac, fid, entry.portvec, spid);
 		chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);



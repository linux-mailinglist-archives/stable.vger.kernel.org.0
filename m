Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E7B53372C
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 09:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbiEYHO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 03:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244251AbiEYHOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 03:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94742D12E;
        Wed, 25 May 2022 00:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2094561722;
        Wed, 25 May 2022 07:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8E9C385B8;
        Wed, 25 May 2022 07:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653462486;
        bh=5k9ulH6n/1XJxgAoQmXLKCvyhdbbBsZsmy5eB4apk5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuxZ5maeX6FDxBNoLauKGxRhzdZEQcdhyKpWiypgONIkmOiW0GJE+CJ6VdI23BUN/
         8asMathGvMw2bmmrHAAZXQFCw7l4flqXChF+AHOiBHoJ2SLiJnLsjqU+xM3a1g6rD7
         3APj+ck4F/hllSMXhIyhzRE33rQ/yzNw/zLnfKVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.281
Date:   Wed, 25 May 2022 09:07:55 +0200
Message-Id: <165346247461173@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <16534624745741@kroah.com>
References: <16534624745741@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 4207e0002fbb..20ad87b8bd56 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 280
+SUBLEVEL = 281
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index b54084f9b77a..e1b3c5c96560 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1071,7 +1071,7 @@ vector_bhb_loop8_\name:
 
 	@ bhb workaround
 	mov	r0, #8
-3:	b	. + 4
+3:	W(b)	. + 4
 	subs	r0, r0, #1
 	bne	3b
 	dsb
diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 31af81d46aae..21c49d3559db 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -51,17 +51,17 @@ int notrace unwind_frame(struct stackframe *frame)
 		return -EINVAL;
 
 	frame->sp = frame->fp;
-	frame->fp = *(unsigned long *)(fp);
-	frame->pc = *(unsigned long *)(fp + 4);
+	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp));
+	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp + 4));
 #else
 	/* check current frame pointer is within bounds */
 	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
 
 	/* restore the registers from the stack frame */
-	frame->fp = *(unsigned long *)(fp - 12);
-	frame->sp = *(unsigned long *)(fp - 8);
-	frame->pc = *(unsigned long *)(fp - 4);
+	frame->fp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 12));
+	frame->sp = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 8));
+	frame->pc = READ_ONCE_NOCHECK(*(unsigned long *)(fp - 4));
 #endif
 
 	return 0;
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 1b6e770bc1cd..8b78694d56b8 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -297,6 +297,7 @@ void cpu_v7_ca15_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0)))
 		cpu_v7_spectre_v2_init();
+	cpu_v7_spectre_bhb_init();
 }
 
 void cpu_v7_bugs_init(void)
diff --git a/arch/mips/lantiq/falcon/sysctrl.c b/arch/mips/lantiq/falcon/sysctrl.c
index 82bbd0e2e298..714d92659489 100644
--- a/arch/mips/lantiq/falcon/sysctrl.c
+++ b/arch/mips/lantiq/falcon/sysctrl.c
@@ -169,6 +169,8 @@ static inline void clkdev_add_sys(const char *dev, unsigned int module,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = NULL;
 	clk->cl.clk = clk;
diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index e304aabd6678..7d4081d67d61 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -124,6 +124,8 @@ static inline void clkdev_add_gptu(struct device *dev, const char *con,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev_name(dev);
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index c05bed624075..1b1142c7bb85 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -313,6 +313,8 @@ static void clkdev_add_pmu(const char *dev, const char *con, bool deactivate,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
@@ -336,6 +338,8 @@ static void clkdev_add_cgu(const char *dev, const char *con,
 {
 	struct clk *clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
+	if (!clk)
+		return;
 	clk->cl.dev_id = dev;
 	clk->cl.con_id = con;
 	clk->cl.clk = clk;
@@ -354,24 +358,28 @@ static void clkdev_add_pci(void)
 	struct clk *clk_ext = kzalloc(sizeof(struct clk), GFP_KERNEL);
 
 	/* main pci clock */
-	clk->cl.dev_id = "17000000.pci";
-	clk->cl.con_id = NULL;
-	clk->cl.clk = clk;
-	clk->rate = CLOCK_33M;
-	clk->rates = valid_pci_rates;
-	clk->enable = pci_enable;
-	clk->disable = pmu_disable;
-	clk->module = 0;
-	clk->bits = PMU_PCI;
-	clkdev_add(&clk->cl);
+	if (clk) {
+		clk->cl.dev_id = "17000000.pci";
+		clk->cl.con_id = NULL;
+		clk->cl.clk = clk;
+		clk->rate = CLOCK_33M;
+		clk->rates = valid_pci_rates;
+		clk->enable = pci_enable;
+		clk->disable = pmu_disable;
+		clk->module = 0;
+		clk->bits = PMU_PCI;
+		clkdev_add(&clk->cl);
+	}
 
 	/* use internal/external bus clock */
-	clk_ext->cl.dev_id = "17000000.pci";
-	clk_ext->cl.con_id = "external";
-	clk_ext->cl.clk = clk_ext;
-	clk_ext->enable = pci_ext_enable;
-	clk_ext->disable = pci_ext_disable;
-	clkdev_add(&clk_ext->cl);
+	if (clk_ext) {
+		clk_ext->cl.dev_id = "17000000.pci";
+		clk_ext->cl.con_id = "external";
+		clk_ext->cl.clk = clk_ext;
+		clk_ext->enable = pci_ext_enable;
+		clk_ext->disable = pci_ext_disable;
+		clkdev_add(&clk_ext->cl);
+	}
 }
 
 /* xway socs can generate clocks on gpio pins */
@@ -391,9 +399,15 @@ static void clkdev_add_clkout(void)
 		char *name;
 
 		name = kzalloc(sizeof("clkout0"), GFP_KERNEL);
+		if (!name)
+			continue;
 		sprintf(name, "clkout%d", i);
 
 		clk = kzalloc(sizeof(struct clk), GFP_KERNEL);
+		if (!clk) {
+			kfree(name);
+			continue;
+		}
 		clk->cl.dev_id = "1f103000.cgu";
 		clk->cl.con_id = name;
 		clk->cl.clk = clk;
diff --git a/arch/x86/um/shared/sysdep/syscalls_64.h b/arch/x86/um/shared/sysdep/syscalls_64.h
index 8a7d5e1da98e..1e6875b4ffd8 100644
--- a/arch/x86/um/shared/sysdep/syscalls_64.h
+++ b/arch/x86/um/shared/sysdep/syscalls_64.h
@@ -10,13 +10,12 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 
-typedef long syscall_handler_t(void);
+typedef long syscall_handler_t(long, long, long, long, long, long);
 
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	(((long (*)(long, long, long, long, long, long)) \
-	  (*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&regs->regs), \
+	(((*sys_call_table[syscall]))(UPT_SYSCALL_ARG1(&regs->regs), \
 		 		      UPT_SYSCALL_ARG2(&regs->regs), \
 				      UPT_SYSCALL_ARG3(&regs->regs), \
 				      UPT_SYSCALL_ARG4(&regs->regs), \
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index b998e3abca7a..1e02cb60b65b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -195,7 +195,7 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 		unsigned int set_size)
 {
 	struct drbd_request *r;
-	struct drbd_request *req = NULL;
+	struct drbd_request *req = NULL, *tmp = NULL;
 	int expect_epoch = 0;
 	int expect_size = 0;
 
@@ -249,8 +249,11 @@ void tl_release(struct drbd_connection *connection, unsigned int barrier_nr,
 	 * to catch requests being barrier-acked "unexpectedly".
 	 * It usually should find the same req again, or some READ preceding it. */
 	list_for_each_entry(req, &connection->transfer_log, tl_requests)
-		if (req->epoch == expect_epoch)
+		if (req->epoch == expect_epoch) {
+			tmp = req;
 			break;
+		}
+	req = list_prepare_entry(tmp, &connection->transfer_log, tl_requests);
 	list_for_each_entry_safe_from(req, r, &connection->transfer_log, tl_requests) {
 		if (req->epoch != expect_epoch)
 			break;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 77f84e906326..d352ac941900 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -516,8 +516,8 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-/* Errors during formatting are counted here. */
-static int format_errors;
+/* errors encountered on the current (or last) request */
+static int floppy_errors;
 
 /* Format request descriptor. */
 static struct format_descr format_req;
@@ -537,7 +537,6 @@ static struct format_descr format_req;
 static char *floppy_track_buffer;
 static int max_buffer_sectors;
 
-static int *errors;
 typedef void (*done_f)(int);
 static const struct cont_t {
 	void (*interrupt)(void);
@@ -1426,7 +1425,7 @@ static int interpret_errors(void)
 			if (DP->flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
-		} else if (*errors >= DP->max_errors.reporting) {
+		} else if (floppy_errors >= DP->max_errors.reporting) {
 			print_errors();
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
@@ -2049,7 +2048,7 @@ static void bad_flp_intr(void)
 		if (!next_valid_format())
 			return;
 	}
-	err_count = ++(*errors);
+	err_count = ++floppy_errors;
 	INFBOUND(DRWE->badness, err_count);
 	if (err_count > DP->max_errors.abort)
 		cont->done(0);
@@ -2194,9 +2193,8 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
 		return -EINVAL;
 	}
 	format_req = *tmp_format_req;
-	format_errors = 0;
 	cont = &format_cont;
-	errors = &format_errors;
+	floppy_errors = 0;
 	ret = wait_til_done(redo_format, true);
 	if (ret == -EINTR)
 		return -EINTR;
@@ -2679,7 +2677,7 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track &&
+		     floppy_errors < DP->max_errors.read_track &&
 		     ((!probing ||
 		       (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
@@ -2813,7 +2811,7 @@ static int set_next_request(void)
 		if (q) {
 			current_req = blk_fetch_request(q);
 			if (current_req) {
-				current_req->error_count = 0;
+				floppy_errors = 0;
 				break;
 			}
 		}
@@ -2875,7 +2873,6 @@ static void redo_fd_request(void)
 		_floppy = floppy_type + DP->autodetect[DRS->probed_format];
 	} else
 		probing = 0;
-	errors = &(current_req->error_count);
 	tmp = make_raw_rw_request();
 	if (tmp < 2) {
 		request_done(tmp);
diff --git a/drivers/clk/at91/clk-generated.c b/drivers/clk/at91/clk-generated.c
index ea23002be4de..b397556c34d9 100644
--- a/drivers/clk/at91/clk-generated.c
+++ b/drivers/clk/at91/clk-generated.c
@@ -119,6 +119,10 @@ static void clk_generated_best_diff(struct clk_rate_request *req,
 		tmp_rate = parent_rate;
 	else
 		tmp_rate = parent_rate / div;
+
+	if (tmp_rate < req->min_rate || tmp_rate > req->max_rate)
+		return;
+
 	tmp_diff = abs(req->rate - tmp_rate);
 
 	if (*best_diff < 0 || *best_diff > tmp_diff) {
diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index b14d481ab7db..cbad11029c67 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -694,6 +694,9 @@ static int mvebu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	unsigned long flags;
 	unsigned int on, off;
 
+	if (state->polarity != PWM_POLARITY_NORMAL)
+		return -EINVAL;
+
 	val = (unsigned long long) mvpwm->clk_rate * state->duty_cycle;
 	do_div(val, NSEC_PER_SEC);
 	if (val > UINT_MAX)
diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 3210fba16a9b..91d6966c3d29 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -135,9 +135,13 @@ static int vf610_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
 {
 	struct vf610_gpio_port *port = gpiochip_get_data(chip);
 	unsigned long mask = BIT(gpio);
+	u32 val;
 
-	if (port->sdata && port->sdata->have_paddr)
-		vf610_gpio_writel(mask, port->gpio_base + GPIO_PDDR);
+	if (port->sdata && port->sdata->have_paddr) {
+		val = vf610_gpio_readl(port->gpio_base + GPIO_PDDR);
+		val |= mask;
+		vf610_gpio_writel(val, port->gpio_base + GPIO_PDDR);
+	}
 
 	vf610_gpio_set(chip, gpio, value);
 
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index ceac9aaf4fe9..64faa70a9dd9 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2910,6 +2910,7 @@ static void fetch_monitor_name(struct drm_dp_mst_topology_mgr *mgr,
 
 	mst_edid = drm_dp_mst_get_edid(port->connector, mgr, port);
 	drm_edid_get_monitor_name(mst_edid, name, namelen);
+	kfree(mst_edid);
 }
 
 /**
diff --git a/drivers/input/input.c b/drivers/input/input.c
index cadb368be8ef..f9f3d6261dc5 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -50,6 +50,17 @@ static DEFINE_MUTEX(input_mutex);
 
 static const struct input_value input_value_sync = { EV_SYN, SYN_REPORT, 1 };
 
+static const unsigned int input_max_code[EV_CNT] = {
+	[EV_KEY] = KEY_MAX,
+	[EV_REL] = REL_MAX,
+	[EV_ABS] = ABS_MAX,
+	[EV_MSC] = MSC_MAX,
+	[EV_SW] = SW_MAX,
+	[EV_LED] = LED_MAX,
+	[EV_SND] = SND_MAX,
+	[EV_FF] = FF_MAX,
+};
+
 static inline int is_event_supported(unsigned int code,
 				     unsigned long *bm, unsigned int max)
 {
@@ -1915,6 +1926,14 @@ EXPORT_SYMBOL(input_free_device);
  */
 void input_set_capability(struct input_dev *dev, unsigned int type, unsigned int code)
 {
+	if (type < EV_CNT && input_max_code[type] &&
+	    code > input_max_code[type]) {
+		pr_err("%s: invalid code %u for type %u\n", __func__, code,
+		       type);
+		dump_stack();
+		return;
+	}
+
 	switch (type) {
 	case EV_KEY:
 		__set_bit(code, dev->keybit);
diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscreen/stmfts.c
index d9e93dabbca2..9007027a7ad9 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -344,11 +344,11 @@ static int stmfts_input_open(struct input_dev *dev)
 
 	err = pm_runtime_get_sync(&sdata->client->dev);
 	if (err < 0)
-		return err;
+		goto out;
 
 	err = i2c_smbus_write_byte(sdata->client, STMFTS_MS_MT_SENSE_ON);
 	if (err)
-		return err;
+		goto out;
 
 	mutex_lock(&sdata->mutex);
 	sdata->running = true;
@@ -371,7 +371,9 @@ static int stmfts_input_open(struct input_dev *dev)
 				 "failed to enable touchkey\n");
 	}
 
-	return 0;
+out:
+	pm_runtime_put_noidle(&sdata->client->dev);
+	return err;
 }
 
 static void stmfts_input_close(struct input_dev *dev)
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 36ea671c912e..79e5acc6e964 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1345,7 +1345,7 @@ static void mmc_blk_issue_discard_rq(struct mmc_queue *mq, struct request *req)
 					 arg == MMC_TRIM_ARG ?
 					 INAND_CMD38_ARG_TRIM :
 					 INAND_CMD38_ARG_ERASE,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
 			err = mmc_erase(card, from, nr, arg);
@@ -1387,7 +1387,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 				 arg == MMC_SECURE_TRIM1_ARG ?
 				 INAND_CMD38_ARG_SECTRIM1 :
 				 INAND_CMD38_ARG_SECERASE,
-				 0);
+				 card->ext_csd.generic_cmd6_time);
 		if (err)
 			goto out_retry;
 	}
@@ -1405,7 +1405,7 @@ static void mmc_blk_issue_secdiscard_rq(struct mmc_queue *mq,
 			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 					 INAND_CMD38_ARG_EXT_CSD,
 					 INAND_CMD38_ARG_SECTRIM2,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 			if (err)
 				goto out_retry;
 		}
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 54686ca4bfb7..45cffccc7050 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -23,7 +23,9 @@
 #include "host.h"
 #include "mmc_ops.h"
 
-#define MMC_OPS_TIMEOUT_MS	(10 * 60 * 1000) /* 10 minute timeout */
+#define MMC_OPS_TIMEOUT_MS		(10 * 60 * 1000) /* 10min*/
+#define MMC_BKOPS_TIMEOUT_MS		(120 * 1000) /* 120s */
+#define MMC_CACHE_FLUSH_TIMEOUT_MS	(30 * 1000) /* 30s */
 
 static const u8 tuning_blk_pattern_4bit[] = {
 	0xff, 0x0f, 0xff, 0x00, 0xff, 0xcc, 0xc3, 0xcc,
@@ -456,10 +458,6 @@ static int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 	bool expired = false;
 	bool busy = false;
 
-	/* We have an unspecified cmd timeout, use the fallback value. */
-	if (!timeout_ms)
-		timeout_ms = MMC_OPS_TIMEOUT_MS;
-
 	/*
 	 * In cases when not allowed to poll by using CMD13 or because we aren't
 	 * capable of polling by using ->card_busy(), then rely on waiting the
@@ -532,14 +530,20 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 
 	mmc_retune_hold(host);
 
+	if (!timeout_ms) {
+		pr_warn("%s: unspecified timeout for CMD6 - use generic\n",
+			mmc_hostname(host));
+		timeout_ms = card->ext_csd.generic_cmd6_time;
+	}
+
 	/*
 	 * If the cmd timeout and the max_busy_timeout of the host are both
 	 * specified, let's validate them. A failure means we need to prevent
 	 * the host from doing hw busy detection, which is done by converting
 	 * to a R1 response instead of a R1B.
 	 */
-	if (timeout_ms && host->max_busy_timeout &&
-		(timeout_ms > host->max_busy_timeout))
+	if (host->max_busy_timeout &&
+	    (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
 	cmd.opcode = MMC_SWITCH;
@@ -550,10 +554,6 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	cmd.flags = MMC_CMD_AC;
 	if (use_r1b_resp) {
 		cmd.flags |= MMC_RSP_SPI_R1B | MMC_RSP_R1B;
-		/*
-		 * A busy_timeout of zero means the host can decide to use
-		 * whatever value it finds suitable.
-		 */
 		cmd.busy_timeout = timeout_ms;
 	} else {
 		cmd.flags |= MMC_RSP_SPI_R1 | MMC_RSP_R1;
@@ -979,7 +979,7 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 
 	mmc_claim_host(card->host);
 	if (card->ext_csd.raw_bkops_status >= EXT_CSD_BKOPS_LEVEL_2) {
-		timeout = MMC_OPS_TIMEOUT_MS;
+		timeout = MMC_BKOPS_TIMEOUT_MS;
 		use_busy_signal = true;
 	} else {
 		timeout = 0;
@@ -1022,7 +1022,8 @@ int mmc_flush_cache(struct mmc_card *card)
 			(card->ext_csd.cache_size > 0) &&
 			(card->ext_csd.cache_ctrl & 1)) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_FLUSH_CACHE, 1, 0);
+				 EXT_CSD_FLUSH_CACHE, 1,
+				 MMC_CACHE_FLUSH_TIMEOUT_MS);
 		if (err)
 			pr_err("%s: cache flush error %d\n",
 					mmc_hostname(card->host), err);
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 1c1bb074f664..066abf9dc91e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -625,6 +625,13 @@ static int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 		err = -ENXIO;
 		goto err_exit;
 	}
+
+	/* Validate that the new hw_head_ is reasonable. */
+	if (hw_head_ >= ring->size) {
+		err = -ENXIO;
+		goto err_exit;
+	}
+
 	ring->hw_head = hw_head_;
 	err = aq_hw_err_from_flags(self);
 
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index 851b6d1f5a42..35bcb2c52dbc 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1410,8 +1410,10 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* alloc_etherdev ensures aligned and zeroed private structures */
 	dev = alloc_etherdev (sizeof (*tp));
-	if (!dev)
+	if (!dev) {
+		pci_disable_device(pdev);
 		return -ENOMEM;
+	}
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	if (pci_resource_len (pdev, 0) < tulip_tbl[chip_idx].io_size) {
@@ -1789,6 +1791,7 @@ static int tulip_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_free_netdev:
 	free_netdev (dev);
+	pci_disable_device(pdev);
 	return -ENODEV;
 }
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 6bd30d51dafc..618063d21f96 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4622,7 +4622,8 @@ static void igb_watchdog_task(struct work_struct *work)
 				break;
 			}
 
-			if (adapter->link_speed != SPEED_1000)
+			if (adapter->link_speed != SPEED_1000 ||
+			    !hw->phy.ops.read_reg)
 				goto no_wait;
 
 			/* wait for Remote receiver status OK */
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index ecd345ca160f..9d384fb3b746 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3629,7 +3629,8 @@ static void ql_reset_work(struct work_struct *work)
 		qdev->mem_map_registers;
 	unsigned long hw_flags;
 
-	if (test_bit((QL_RESET_PER_SCSI | QL_RESET_START), &qdev->flags)) {
+	if (test_bit(QL_RESET_PER_SCSI, &qdev->flags) ||
+	    test_bit(QL_RESET_START, &qdev->flags)) {
 		clear_bit(QL_LINK_MASTER, &qdev->flags);
 
 		/*
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index cc1e887e47b5..3dec109251ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -261,7 +261,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 
 	/* Enable pci device */
-	ret = pci_enable_device(pdev);
+	ret = pcim_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n",
 			__func__);
@@ -313,8 +313,6 @@ static void stmmac_pci_remove(struct pci_dev *pdev)
 		pcim_iounmap_regions(pdev, BIT(i));
 		break;
 	}
-
-	pci_disable_device(pdev);
 }
 
 static int __maybe_unused stmmac_pci_suspend(struct device *dev)
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 98fc34ea78ff..c6feb7459be6 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -595,6 +595,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					dev_kfree_skb_any(rbi->skb);
+					rbi->skb = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
@@ -619,6 +620,7 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 				if (dma_mapping_error(&adapter->pdev->dev,
 						      rbi->dma_addr)) {
 					put_page(rbi->page);
+					rbi->page = NULL;
 					rq->stats.rx_buf_alloc_failure++;
 					break;
 				}
@@ -1571,6 +1573,10 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 	u32 i, ring_idx;
 	struct Vmxnet3_RxDesc *rxd;
 
+	/* ring has already been cleaned up */
+	if (!rq->rx_ring[0].base)
+		return;
+
 	for (ring_idx = 0; ring_idx < 2; ring_idx++) {
 		for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
 #ifdef __BIG_ENDIAN_BITFIELD
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 97a0c2384aee..4b431ca55c96 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3639,6 +3639,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
+		if (cmd->sg_mapped)
+			qlt_unmap_sg(vha, cmd);
+
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0f49ab48cb14..93e21e319d70 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10228,6 +10228,9 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * Do not allow to attach to a group in a different task
 		 * or CPU context. If we're moving SW events, we'll fix
 		 * this up later, so allow that.
+		 *
+		 * Racy, not holding group_leader->ctx->mutex, see comment with
+		 * perf_event_ctx_lock().
 		 */
 		if (!move_group && group_leader->ctx != ctx)
 			goto err_context;
@@ -10277,11 +10280,22 @@ SYSCALL_DEFINE5(perf_event_open,
 			} else {
 				perf_event_ctx_unlock(group_leader, gctx);
 				move_group = 0;
+				goto not_move_group;
 			}
 		}
 	} else {
 		mutex_lock(&ctx->mutex);
+
+		/*
+		 * Now that we hold ctx->lock, (re)validate group_leader->ctx == ctx,
+		 * see the group_leader && !move_group test earlier.
+		 */
+		if (group_leader && group_leader->ctx != ctx) {
+			err = -EINVAL;
+			goto err_locked;
+		}
 	}
+not_move_group:
 
 	if (ctx->task == TASK_TOMBSTONE) {
 		err = -ESRCH;
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index e73617b11af1..bdc2b89870e3 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -600,10 +600,14 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 	 */
 	for (i = 0; i < nslots; i++)
 		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
-	if (!(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-	    (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
-
+	/*
+	 * When dir == DMA_FROM_DEVICE we could omit the copy from the orig
+	 * to the tlb buffer, if we knew for sure the device will
+	 * overwirte the entire current content. But we don't. Thus
+	 * unconditional bounce may prevent leaking swiotlb content (i.e.
+	 * kernel memory) to user-space.
+	 */
+	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
 	return tlb_addr;
 }
 EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 10fa84056cb5..07e7cf2b4cfb 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -47,6 +47,13 @@ static int br_pass_frame_up(struct sk_buff *skb)
 	u64_stats_update_end(&brstats->syncp);
 
 	vg = br_vlan_group_rcu(br);
+
+	/* Reset the offload_fwd_mark because there could be a stacked
+	 * bridge above, and it should not think this bridge it doing
+	 * that bridge's work forwarding out its ports.
+	 */
+	br_switchdev_frame_unmark(skb);
+
 	/* Bridge is just like any other port.  Make sure the
 	 * packet is allowed except in promisc modue when someone
 	 * may be running packet capture.
diff --git a/net/key/af_key.c b/net/key/af_key.c
index d7adac31b0fd..3d5a46080169 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2834,8 +2834,10 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
+	if (err)
+		return err;
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a38be9145ff..e60a53c056c0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1204,8 +1204,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 		goto dont_reorder;
 
 	/* not part of a BA session */
-	if (ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK &&
-	    ack_policy != IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)
+	if (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NOACK)
 		goto dont_reorder;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 5405d073804c..9e3f9460f14f 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -130,7 +130,7 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 
 		skb_frag = nci_skb_alloc(ndev,
 					 (NCI_DATA_HDR_SIZE + frag_len),
-					 GFP_KERNEL);
+					 GFP_ATOMIC);
 		if (skb_frag == NULL) {
 			rc = -ENOMEM;
 			goto free_exit;
diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index c972c212e7ca..e5c5cff33236 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -165,7 +165,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 
 	i = 0;
 	skb = nci_skb_alloc(ndev, conn_info->max_pkt_payload_len +
-			    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+			    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
@@ -198,7 +198,7 @@ static int nci_hci_send_data(struct nci_dev *ndev, u8 pipe,
 		if (i < data_len) {
 			skb = nci_skb_alloc(ndev,
 					    conn_info->max_pkt_payload_len +
-					    NCI_DATA_HDR_SIZE, GFP_KERNEL);
+					    NCI_DATA_HDR_SIZE, GFP_ATOMIC);
 			if (!skb)
 				return -ENOMEM;
 
diff --git a/sound/isa/wavefront/wavefront_synth.c b/sound/isa/wavefront/wavefront_synth.c
index 13c8e6542a2f..9dd0ae377980 100644
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -1092,7 +1092,8 @@ wavefront_send_sample (snd_wavefront_t *dev,
 
 			if (dataptr < data_end) {
 		
-				__get_user (sample_short, dataptr);
+				if (get_user(sample_short, dataptr))
+					return -EFAULT;
 				dataptr += skip;
 		
 				if (data_is_unsigned) { /* GUS ? */
diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 275f1c3c73b6..4334f2af15fa 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1631,7 +1631,7 @@ static int __bench_numa(const char *name)
 		"GB/sec,", "total-speed",	"GB/sec total speed");
 
 	if (g->p.show_details >= 2) {
-		char tname[14 + 2 * 10 + 1];
+		char tname[14 + 2 * 11 + 1];
 		struct thread_data *td;
 		for (p = 0; p < g->p.nr_proc; p++) {
 			for (t = 0; t < g->p.nr_threads; t++) {

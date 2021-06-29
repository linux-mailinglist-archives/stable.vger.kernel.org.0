Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A42B3B78CF
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 21:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhF2Tq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 15:46:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:14755 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhF2Tq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 15:46:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="187910820"
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="gz'50?scan'50,208,50";a="187910820"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 12:44:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="gz'50?scan'50,208,50";a="641439790"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 29 Jun 2021 12:44:25 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lyJei-0009Jn-Nk; Tue, 29 Jun 2021 19:44:24 +0000
Date:   Wed, 30 Jun 2021 03:44:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>
Cc:     kbuild-all@lists.01.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] printk/console: Check consistent sequence number when
 handling race in console_unlock()
Message-ID: <202106300338.57cbEezZ-lkp@intel.com>
References: <20210629143341.19284-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20210629143341.19284-1-pmladek@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Petr,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.13 next-20210629]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Petr-Mladek/printk-console-Check-consistent-sequence-number-when-handling-race-in-console_unlock/20210629-223408
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git c54b245d011855ea91c5beff07f1db74143ce614
config: x86_64-buildonly-randconfig-r006-20210629 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/24c9c4e757be2efe5bb225e443b3502338abf64c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Petr-Mladek/printk-console-Check-consistent-sequence-number-when-handling-race-in-console_unlock/20210629-223408
        git checkout 24c9c4e757be2efe5bb225e443b3502338abf64c
        # save the attached .config to linux build tree
        make W=1 ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/printk/printk.c:175:5: warning: no previous prototype for 'devkmsg_sysctl_set_loglvl' [-Wmissing-prototypes]
     175 | int devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/printk/printk.c: In function 'console_unlock':
>> kernel/printk/printk.c:2548:6: warning: variable 'next_seq' set but not used [-Wunused-but-set-variable]
    2548 |  u64 next_seq;
         |      ^~~~~~~~


vim +/next_seq +2548 kernel/printk/printk.c

  2525	
  2526	/**
  2527	 * console_unlock - unlock the console system
  2528	 *
  2529	 * Releases the console_lock which the caller holds on the console system
  2530	 * and the console driver list.
  2531	 *
  2532	 * While the console_lock was held, console output may have been buffered
  2533	 * by printk().  If this is the case, console_unlock(); emits
  2534	 * the output prior to releasing the lock.
  2535	 *
  2536	 * If there is output waiting, we wake /dev/kmsg and syslog() users.
  2537	 *
  2538	 * console_unlock(); may be called from any context.
  2539	 */
  2540	void console_unlock(void)
  2541	{
  2542		static char ext_text[CONSOLE_EXT_LOG_MAX];
  2543		static char text[CONSOLE_LOG_MAX];
  2544		unsigned long flags;
  2545		bool do_cond_resched, retry;
  2546		struct printk_info info;
  2547		struct printk_record r;
> 2548		u64 next_seq;
  2549	
  2550		if (console_suspended) {
  2551			up_console_sem();
  2552			return;
  2553		}
  2554	
  2555		prb_rec_init_rd(&r, &info, text, sizeof(text));
  2556	
  2557		/*
  2558		 * Console drivers are called with interrupts disabled, so
  2559		 * @console_may_schedule should be cleared before; however, we may
  2560		 * end up dumping a lot of lines, for example, if called from
  2561		 * console registration path, and should invoke cond_resched()
  2562		 * between lines if allowable.  Not doing so can cause a very long
  2563		 * scheduling stall on a slow console leading to RCU stall and
  2564		 * softlockup warnings which exacerbate the issue with more
  2565		 * messages practically incapacitating the system.
  2566		 *
  2567		 * console_trylock() is not able to detect the preemptive
  2568		 * context reliably. Therefore the value must be stored before
  2569		 * and cleared after the "again" goto label.
  2570		 */
  2571		do_cond_resched = console_may_schedule;
  2572	again:
  2573		console_may_schedule = 0;
  2574	
  2575		/*
  2576		 * We released the console_sem lock, so we need to recheck if
  2577		 * cpu is online and (if not) is there at least one CON_ANYTIME
  2578		 * console.
  2579		 */
  2580		if (!can_use_console()) {
  2581			console_locked = 0;
  2582			up_console_sem();
  2583			return;
  2584		}
  2585	
  2586		for (;;) {
  2587			size_t ext_len = 0;
  2588			size_t len;
  2589	
  2590			printk_safe_enter_irqsave(flags);
  2591	skip:
  2592			if (!prb_read_valid(prb, console_seq, &r))
  2593				break;
  2594	
  2595			if (console_seq != r.info->seq) {
  2596				console_dropped += r.info->seq - console_seq;
  2597				console_seq = r.info->seq;
  2598			}
  2599	
  2600			if (suppress_message_printing(r.info->level)) {
  2601				/*
  2602				 * Skip record we have buffered and already printed
  2603				 * directly to the console when we received it, and
  2604				 * record that has level above the console loglevel.
  2605				 */
  2606				console_seq++;
  2607				goto skip;
  2608			}
  2609	
  2610			/* Output to all consoles once old messages replayed. */
  2611			if (unlikely(exclusive_console &&
  2612				     console_seq >= exclusive_console_stop_seq)) {
  2613				exclusive_console = NULL;
  2614			}
  2615	
  2616			/*
  2617			 * Handle extended console text first because later
  2618			 * record_print_text() will modify the record buffer in-place.
  2619			 */
  2620			if (nr_ext_console_drivers) {
  2621				ext_len = info_print_ext_header(ext_text,
  2622							sizeof(ext_text),
  2623							r.info);
  2624				ext_len += msg_print_ext_body(ext_text + ext_len,
  2625							sizeof(ext_text) - ext_len,
  2626							&r.text_buf[0],
  2627							r.info->text_len,
  2628							&r.info->dev_info);
  2629			}
  2630			len = record_print_text(&r,
  2631					console_msg_format & MSG_FORMAT_SYSLOG,
  2632					printk_time);
  2633			console_seq++;
  2634	
  2635			/*
  2636			 * While actively printing out messages, if another printk()
  2637			 * were to occur on another CPU, it may wait for this one to
  2638			 * finish. This task can not be preempted if there is a
  2639			 * waiter waiting to take over.
  2640			 */
  2641			console_lock_spinning_enable();
  2642	
  2643			stop_critical_timings();	/* don't trace print latency */
  2644			call_console_drivers(ext_text, ext_len, text, len);
  2645			start_critical_timings();
  2646	
  2647			if (console_lock_spinning_disable_and_check()) {
  2648				printk_safe_exit_irqrestore(flags);
  2649				return;
  2650			}
  2651	
  2652			printk_safe_exit_irqrestore(flags);
  2653	
  2654			if (do_cond_resched)
  2655				cond_resched();
  2656		}
  2657	
  2658		/* Get consistent value of the next-to-be-used sequence number. */
  2659		next_seq = console_seq;
  2660	
  2661		console_locked = 0;
  2662		up_console_sem();
  2663	
  2664		/*
  2665		 * Someone could have filled up the buffer again, so re-check if there's
  2666		 * something to flush. In case we cannot trylock the console_sem again,
  2667		 * there's a new owner and the console_unlock() from them will do the
  2668		 * flush, no worries.
  2669		 */
  2670		retry = prb_read_valid(prb, next_seq, NULL);
  2671		printk_safe_exit_irqrestore(flags);
  2672	
  2673		if (retry && console_trylock())
  2674			goto again;
  2675	}
  2676	EXPORT_SYMBOL(console_unlock);
  2677	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--WIyZ46R2i8wDzkSu
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICIxv22AAAy5jb25maWcAjDxJd9w20vf8in7OJXNwRpJljf2+pwNIgt1IEwQNgK3lwqfI
bY/eyFJGS8b+918VwAUAi53k4IhVhb12FPrnn35esdeXx283L3e3N/f3P1Zf9w/7p5uX/efV
l7v7/f+tCrWqlV3xQthfgbi6e3j9/s/vH866s9PV+1+P3/16tNrunx7296v88eHL3ddXaHz3
+PDTzz/lqi7Fusvzbse1EaruLL+052++3t6+/bj6pdj/fnfzsPr4K3Tx9uTkH/6vN0EzYbp1
np//GEDrqavzj0fvjo5G2orV6xE1gplxXdTt1AWABrKTd++PTgZ4VSBpVhYTKYBo0gBxFMw2
Z3VXiXo79RAAO2OZFXmE28BkmJHdWllFIkQNTXmAUrWxus2t0maCCv2pu1A6GDdrRVVYIXln
WVbxzihtJ6zdaM5guXWp4B8gMdgUzuvn1dqd/f3qef/y+sd0gqIWtuP1rmMali+ksOfvTqZJ
yUbAIJabYJBK5awadunNm2hmnWGVDYAbtuPdluuaV936WjRTLyEmA8wJjaquJaMxl9dLLdQS
4pRGXBuLvPHzqscF813dPa8eHl9w12Z4N+tDBDj3Q/jL68OtVYhOkafEjHEhRJuCl6ytrDvr
4GwG8EYZWzPJz9/88vD4sP/Hm6lfc8EaokNzZXaiCTj+gtl8031qecvDaeVaGdNJLpW+6pi1
LN+QK24Nr0RGDOROiWnom7WgpGBcYL1qYGmQjtXz6+/PP55f9t8mll7zmmuRO+FptMoCKQtR
ZqMuaAwvS55bgUOXZSe9ECV0Da8LUTsJpTuRYq1BLYCIkGhR/4ZjhOgN0wWgDOx6p7mBAeim
+SaUI4QUSjJRxzAjJEXUbQTXuKNXMbZkxnIlJjRMpy4qHmqjYRLSCHrdPWI2n2hfmNXisoNj
BDUC2o6mwvXrndu/TqqCJ5NVOudFr+3gFCasaZg2fPlUCp6169I4Jt0/fF49fkm4aDI7Kt8a
1cJAnrsLFQzjWDIkcaL1g2q8Y5UomOVdBTvc5Vd5RfCjU+i7ib0TtOuP73htidMIkF2mFSty
FmprikwCH7Dit5akk8p0bYNTTrRlowwcXN60brraOPOSmKeDNE5o7d23/dMzJbdgQ7edqjkI
ZjCvWnWba7RE0snKqDMA2MCEVSFyUqf4dgJYmNArHlm24WbD/9CH6axm+TZiqhTj+S+ZYjQ3
sd4gC/ebEM+vZ7vZPox2tCmTjecA6n4LGczx3wWr7ajEJxK3y/BJbTFSTVw2zhfBbd1osRv7
U2VJTjvueDx2zblsLOxEHRmAAb5TVVtbpq/Io+qpiHMa2ucKmgdSnm9A/HOl+bBe4Lh/2pvn
/6xeYFtXNzDX55ebl+fVze3t4+vDy93D12kTdkJbx6Isd/1GZ00gUTRi/ePElWrtjsvPju0S
49AYEX2MW10Ig65cESqlv7GekTthssKoajA2bj903q4MIWKwnx3gponAR8cvQZLC7Y0oXJsE
BEJtXNNeaxCoGagtOAVHoSLmBD51VU1iH2BqDrtr+DrPKhEqMMSVrFatPT87nQO7irPy/Phs
YjuPM9bLL8F9bjSVZ7jFi9PunMcts/D04t0fOWfr/wgFRGw30DzRESEztRAWeEff8zxq8eGQ
ze2/959f7/dPqy/7m5fXp/2zA/eTILCR+jBt00DwYLq6lazLGMRZecTMk5LJ0ADC6G0tWdPZ
KuvKqjWbWWAjant88iHpYRwnxS6NG8NHMeH1ICXDoGut2iawiA1bc68qeOBWgPuZr5PPbgv/
izRgte37IzWUR/kzIE6qRzeiMOn0Ol2EAUwPLEGmrt0kpyEa8IKtOTR8wXcip8xZj4cuQCnZ
qNd+ZlyXh3pGrX4ALYXJl4d1PlU06Ibn20bBeaMRBB+Pk533erK1arbxU5xRGugfzAD4iuHZ
p5hudxLOQPOKXREd4jHDLjp3TQfduW8moUvvtWGUNHVWLIeCgFsOAwGZhoATJgxfHaGKFoCQ
U7plH64OS1IK7WOqWEAiVQN2SlxzdFccBygtQaZIBkqoDfwRZUuUbiAeAG2go4AFFZQojs+i
g8ltBSYl543z3p2iTD3J3DRbmBPYLJzUhB0t0bgOCaIvQDI0zUJrbjE+G5yaRR4inJ7SBziU
1+GcWO+7xd4MsPSWnAhIAAnnVen8FNrvibeB4lcGwUzsppYt+KLJJ2iecJ68UfRWiHXNqjAP
5tYYAlyAUEbZELMBXUnOnwkqQyFU1+rYkBQ7Aevoz8BEujhjWotQXW+R5EqaOaSLYqMJmoHz
A7uALB4Z6pHC7SKqBIzpw6UhXznjUlJa3VkvNGvTNGENdT44nsMwuQzCcYg+A5/PqcYEBp3x
ogiVmZcJmEqXxngOCLPsdtIFzBE35sdHkYZwxr/P1zb7py+PT99uHm73K/7n/gFcRwZuQY7O
I4Qdk0dIDuunTQ7eOxd/c5hptjvpRxnsM+XwYLqRgbcRBpSmYlnEjVWb0aqgUksIlsERavAN
eleCEg0kQquMPmWnQTMoGQ8b4jFTA44vxTRm05YluGvOFyGSHCAElssOwmuGmWZRinxw3AM9
o0pRgQgR/Tt16mxrlMSIs7sD8dlpFkaNly6zH32HJtDnn1FnFzxXRSiU4D834EI7C2LP3+zv
v5ydvv3+4ezt2emYTkTPFAzy4O8FS7YQNnt/eYaTMkzgo8BJdDF1DXZV+EzF+cmHQwTsMkhY
xwQDPw0dLfQTkUF3ECP0dGNOhFUi05jEKdCxSGaMKgKDMNQwlwQOzhIYvmvWcK42kXpw+bx7
5mNOiCUCPxgDnQHltAZ0pTGJtGnDq4iIzvEdSebnIzKua59XAzNnRBamo3p/3WBycwntAgK3
MazqNi0Y4CqbSK5VDZsk2bsgne9St65xyoqdCVVnHC20LnUbKKUSbDJnurrKMSfIA6+hWfsQ
qQINA+blfRKVGAZzckyIB8BzL49OWzZPj7f75+fHp9XLjz98nB2EUsmaAo4Op41LKTmzreYd
ptEjlwGRsnFJSVI5rVVVlMJsKE+PW7DjIk6oYH+e18DN0hXZJ9LwSwtniHyx7FwgHegRvE1o
jIkXxOTUtI87AlWhTAkRr5hDxlgg6Go80f4eoGSiakMD6uMAJYFJSnDCMdEo+hBuyqhdAYOD
FwG+6bqFmIJcuNx+oOGNoXOEEi057buDnlPUpo0qIfQ0hp3UNahN0BawIDAEorTnZyFJdbyM
syaP+wOv4jLfrBN9jenZXQwBzSZkKx1blEyK6irIfyCBOxNwyqUJNLoAEXVs2wEm7nAnL2cM
PVmmnBs8BcMrnoSaMD6ctWcpyrr3eGAtqtnmaq3qA81ycB5YG6xgQFxvmLoMbxs2Dbfes01g
HIIJVOLaBntdyICP10xbYObIKoFJiOS9dorWoJMAqjbja7Qsxx9PaDze4lDY3hWhcBHMC4eR
s+ynTPjF3cp2rBEJHNzxOVBziLitj/Uyrba89nEkXj8l3BUKfg+oFFh7vmb51UzVuauQ5Pxn
FMABC+rIt//Nc5bX0IGH+e3x4e7l8SlK5gb+a6/MNGsChg7xTqmpi16z9J7TwgDhrI7PZm4U
Nw3Yo1Q4hxucntMSt86fRlPhP5zUyOLDNop9RQ7yBiplabeMTvsH/hFLm/ve2cd4xoXQsNnd
OkO/YWa58ob54gZjRU6npnBPQbEDn+f6iszhYzov7BhbIGxhluAVsLwRQ7OgE9zVAAL7YnpN
ejyVhTgfwtlbPytGODgjehDCBO9U22Cu8PYx2DRRIedXg43C672Wnx99/7y/+XwU/BfpbMyH
gX+pDIaOum0ozkD5g4kxOQw8kfoOaDNlNZ0ZcSvxcczCRhvwf2NmaKW7WI4Z1slUP6Xef8Ip
bfkVzRC8FFQu+7o7PjqKLPp1d/L+iOwCUO+OFlHQzxE5ArDBUVgScclpq+8w6JXTLlmumdl0
RSupjGSzuTICFS2IBcQxR9+P4+OGGAAjvpjr/DFgbg0zEfGeO+fdtQrN7DAKxB3rGkY5iQYp
rsAs43W7PxWISPDSI8wejgN6Emq7gNuqdt37MVMea+TCgIA+Cp8kWCIbNtPHVrvCBEU53nak
2jLyc1OSS1VX9OVhSolXkPS5ygK9aVwi5Z6AnIsSNrOw3ewe3oVqldjxBi9CIutxIICYBYKs
KLpBz4Y4uWnwoDAe9aENnmqqujAR4zNcXhk6V1MUo518/N/+aQVm7Obr/tv+4cVNBRXp6vEP
rNkL4pk+wAscij7iI24lBpTZisYlvyiZkJ2pOA+UyQCJAyWAYrJ/oJ3SHRKCyi13NRNk91EX
s9sG7LbYYWK78Eh6iljDNl/6OFOq2/6Ozy4sOq+2UUdDaOCrXyJjevHJOx5YWiRywaeLe7rr
pKt0f+NIGU85wM2+BhFxWsmAo6i2bdqZFOuN7cutsElT5EknfeLKLwOdArS+YzpnsjtI6zZz
Hefso76aXHeJknSIsilsOvlGpKB0NxCm+a5TO661KDiVukAa0PpT/U+IYOliM2bBuF+l0Nba
8DbaAXcwoJrtQMmoWMahLCuSLgp/pxuCXDCnObCNSSc7xWC5O4ZFNNa+LCETuGhkyjSxgaBH
YOu1Bt6ys/7sBhxcVqUNh4SCT3CmfplTkX6HMJvTNmvNinQFKY5gvKWNb3JkHZVyE/xtQch4
uoZhA4Tq46d4KJNRysq35MWMPG+NVejb2Y0qaI/Ns3HRoiLDDPMFgwA8tXsh8cyzdoNLRimV
SbRZw4OzjuFdLcWsR0QsTaFobFCthF9jhBXB4HhLsdOzvvmlhWhyqXf/dyiuDfo9qgGui0on
c1BeF/kMG9xIg8LFMruYhDwH25izD6f/OlomDdw3tBJ9pmGoQ1qVT/v/vu4fbn+snm9v7n20
GqU7ULDJ4iq69dix+Hy/D2rvse7Hi3jUO8K6tdqBX1gUC/emEZ3kdbuQeBlpbK/jgon62YyO
0F/6H74u7fV5AKx+AYFc7V9uf/1HEM6DjPqYNLLFAJXSfyzcpAKz1NnJEUz3Uys0HSwJw0CH
02EL4gpwq0DWKW7EmDW6h3IR1JUpM/IgF5bpt+Du4ebpx4p/e72/STwzl5QLcwfBYJdhSr13
q+egGQlmeFqMqTGSgJMO80i+intqOU1/NkU38/Lu6dv/bp72q+Lp7s/oFpGBUje5dLbBqlyF
mn9EOc8hLQ326CZqGQSxAzJoSxwPL8IrbPCyVRlopVJo6XSp97HDAQopyHQJwH3hQJQnhLkw
8M9ZvsE4AgINDHbB1FdVxvIocyNMjqXQWUmp4vKiy8v12P9UkBDAh2iFLjbI5em/Li+7egeB
GpWjVmpd8XHdQXrTI0yU8vQwzIS7FGDilvVorJpStVGxupkhfSbSuZsL1x1+Zpjmz9qyxEur
fuDldQTdD8Sz+e2aMRKy+69PN6svA69+drwaFsYtEAzoGZdHpnK7i+6FsVy0Bdm6dhJLaQ7w
aXaX74/D+zBMW7HjrhYp7OT9WQqFaLw1Y5nrcM1783T777uX/S0Gmm8/7/+AqaPOnYV6gw8T
5Y+H4AKUQeji/tbKBmxGxiMR9G+bXLoHE2OlTS5fYjIXgQ9kQeya3uX5suYxFmprp56wGixH
1zJxDDH0xddFVtRdhk9Sko4EcAUGz8T96pYceYt3axRCNTS87wbD85IqaCrb2qfFIABBz5t6
3AFktZx5Xrg+1+MGwrIEifYIvVOxblVLVP5DdO0ttH8IQbjToP0tZjX6qrY5geFDonMB2SeI
5WzT/cz9ezNfOdBdbITlcVHueGVsxqyVexHgW6RdGolpmP5pWXoG4IeBLGEuAq9ye05Be53S
RdU28fHgI7fFhpuLLoPl+MrFBCfFJXDnhDZuOgkRlhPhtW2ra7AOsPFRYVNa5UNwA3r9mAZx
RZX+ptq1oDohxh8KdnS/RZjDpE4tkvQD2LBmKuYNz8udYSUfLiqTrnqov5ZawBWqXagv6J0X
9E78g57huSFBq6oioKdWZHiOBAdQfY1G4BsdaIJ7WwEjJMhZhcGkGmN4qFsDDMqEImt+4nRP
ZZV/FLuUDxoJQDxDVwvh/QON2aIuBNL2fOPMc8pc+eLzGBKNLpjrLaH7y/cVXqP/5SMLqZDh
27SKzoNlCh7UbI13P2hxsHAFU7F/l44YyosC4LE+Ls2nOc50SJgMmnZNDmVU6VSsvZqtoxgu
q3iORWITHlAt5vHQKmJ5KQopsX38Uli0V+4tIHEQODTigERd1CnJaAPcCMN1ArWEqBwrtfA4
B9I4xa2mCi+i36A8a6mTkIToqkc7cryBSafpub5/qDe32rDBwj/BGAvZJoo+pozNCaokI9Z9
tvndLCjr8SxPLwLHuC4TvoTh4JtY5Lvx4IJKywF6sPF0R7T160eB5QvXSBHJgdT15DpYcFDs
8C5ZXwR1cQdQaXPP6jHNtIIGDgbi5f7KrfcYpnshsKNhySmZrQsqfIcb7DlvDI7tMmb2mt+b
4/7xWu/4UBpiqbI+Vuh9OS6ooaEOl5BSDI2mUN5HC7navf395nn/efUfX6/7x9Pjl7v7qIAC
ifrDIDp22D5d2w0F9EPN6YHuo43A33bAMGS4FElqVv8imBm6Arshsdg9FF9X2W2wPPk8uPrt
NSR9yed0p3vTll6EZFWUh8e3Ii6M1/xTG4UzwyuSzKxJYCWyORwv0tdahJp+hurs8dEcjfWH
RQwe7jKdc6Rj3EVmZ4BOfkr7RZYK8xshdBwyeh9lsEqvYdTlKaK9DAxilCg2kmBMncyq2Jub
p5c7PP6V/fFH/6yt7wmWbIV35vtbP+qcTaHMRBokh0oRgaf8ZTJixBSz5BouR37CtOMMhg6O
UDHYXWH6nyxQ07u8IE6HdkL5uq4CjGVa9Rmgt1fZQk53oMhKOrkcD/3TuJ1Yih6mHOrjIHCv
+0MzDXiHbR1LSHINaRWGd1oGv6rgBNY39n5GyKz6woDaXUC6bV/AjUkB94MThSNzt8cTyTIm
bawv6KYz+KgTMfGHV40Vaxp0X1lRaIwowWekY+zhzUiX8RL/hyFa/KMGAa2vYrjQ0Hm45ulu
3vER/76/fX25+f1+737KZ+VK2F4CjspEXUqLhmHmfVCo3oAEbOuJTK5FEzkFPWLpSaDCGyzZ
hKK1NFe3ELn/9vj0YyWni4N5vcKheqypmEuyumUUZgK5Yhv3oqypuK8go3qCOEbDHxRq19dp
pNUZM4o0A4HvjNehtemXE77cDpnBDzBQ9Xm8SCdEGCol11TgRDbWKzCsKz2lRujJsDTSxuLd
j5Ch00G4qflCxtOFS5qjUojCNuIHUXKX3OoSrwarn5xQdTZ9weKiRwhjszAdJmUbplumOi9D
JceH58TuGP0PYRT6/PTo41m0O39ZtT6DTxeIRPy45Hz61JjdNF2f15z2uOJg3bBcnBKz+OIX
PhevvkdcaOwRmNxvIAjfn5jz448D7LpR4VXOdRYGwdfvSohjgm8zf6M2wJyzfKCa3r3rGPK4
YQdwWlxrPqYYHXPha13aBBbDy6shDXHI6fe1+N68RcHtSNG4Fz9xeL+RoGoEpnnDefaVWbhM
yu8EyU9+RCsawwX5oe6SvWlxqYFuw6tmeIra69RltTnNqeZ25lgV+z/vbokLPB+uQzAbLgq/
l2LIyPVJP4ISqAnoNIIX3Kmcs7+fwDZIQqkTALPQEvaAqU48vAWGReSaLvt07UxD6QTXsJF8
1lnRLPcFJ7fQF/4OUrwfSz+MhDh3X22S/Yuf0bjKFdtmMYTZpBXPmYwhqNAr9E08LFkfCNxu
8Tq90dRFuMMwI4pknPTayG0Q5kVsC+I1+zGZlIrIKMyJMNt8mOLwI/eAjOsT/CeQ6okRSWBS
VpdiOpFJGpsv9oiY7tq+f//+6ADB7AdWQgqzcQlvHzLlYnX7+PDy9HiPv/nxOZVwt/pLfFZ6
2dUXVXx+GH+yWMQ6nbP/p+zZlhu3kf0VP53ardo5I1GiLg/zAJGUxDFBcghKovPCcsZOxhXH
dtlObfL3pxvgBZcGPWdrk1jdDRDXRqNvqGRuOGdeJSYh3aOjVBZxErdoXyeB0Flur84G++75
CNoDQJjQRTBZG0M1vt0TBXR3pWxpfTzlMYZnJnwC220tcxx4EqesTq5xkhZEQ898MErH928P
vz9d0KyMExU9wx/ir5eX59d3a4rii9X6+NLPggU1PG47GLrY0VBPJRJl+eMiK2lu8oL2lJGM
gzcr3w6Dw4xV80VjTrS0INeG9UGHUgttRPrWGioCOVxg2821PeVVDWfqiobSq7pHJnSmD0lz
TAVyYjrQXDL6RNBCMZaWu2y+XVqt6sHUDA04Z4rQqrleWq75nXQwtdrUrev5V2APD4+IvrdX
o/mVjN3AXotYmeAyX5Lfm6hO1Xd7d4/xVRI9MinMfjZ+tHct+5B2UNnQHG/ghsnT3cvzw5O5
wTAgrzfwmiu+gw9Ohx7Ok5R7S5TroXltJIEymjA06u2/D+/ff9Cc2miPuMD/0zo61nYYi1a/
v7ZBrG8y87aEACv5UQdqK3aRjJvlsW/rA+en9G0VK9NY13p1gLYW6TqYu/A4FSrrIUauLGY2
urubVk1bN628h+ntHSrBmLD84HOTGsg8N6PxYyeOmmT9lO1x0RFGg/o2x1a1EdwOHBm7un15
uENtm5oc5yTWxiZcN8Q3S9FK7ul8FEusNhNdwaKwSwOqcNUI56AaM5bRbR6djh6+d5eGq2LQ
zwyfOCk7i7qnkHfuc81L09uth7UcrTO0S1Ees8zNKCi/NTj1ybTDzhwMTlyPz8BPXsfB319A
KGZGcosBJK+OMdSoK8YauEqOrnRj9tyxlPS4UH3XW0oSkCpvpwDqVyrlB2V4B9raANdnretu
X2WXIvJs6uX6KyjczC8Glpw6NAnEVXo2nLoVNDlXugZNQWWgjSrQwn2+0N1HtOh5GQvkSc+L
6PMpwxwTOxAP69TQ0xWRydGq5GDc0NXvNg0iByaMOIcOeJk7IM4NZtZVqGdzRN4jzfpyvezN
qUfkPoFbiHLtIqfMs6sGL+k7eVM3thm6wypbEYZctBmdlWlXz1tW0iKKxDUpiUPZJkvhR5uV
lGr3G6zKNtmlBnPhx9R1qdacoPteDDOc6959+KuFzaF0H6OXKIJ5fd2hKH2KLJhW+7G0jjnt
GgfB6zFWbrD1vNy+vpmGmBr9LtbSRiSMwuh1uwKplkJp5jgbpSx0IDADa6mZqcEd0XXVeMJ7
lfNIKTJVuZcKFqJ03yWoHAtX32s5GCf4EwQ4NAup5E316+3Tm/L7vspu/3GGZ5ddw8a3B8dU
He9rY0Jz+E2Fu+cWXbWPW5pUiL0ekSZ49wmtCUVRCmJ4lakP9f6Y4bpyT2vGP1cF/7x/vH0D
SerHw4t7Yss53qd27V+TOIkkC6NMkEAA/MzOQN5VhcZLmXLP8HPskXD1srTBPWYHB94Nagyt
xOwOYfazhIek4ElNxggjifKZya/bSxrXx3ZuNtbCBpPYpdvRdE7ArFqKuiSIMCwdX5xwB5bH
Rn7EHg7iBHOhpzq1llGl69AkwMwEJjnETiR5TQtS/uWkbl63Ly8PT7/3QDSGKarb7xhIbK05
kAOgl7062GYtxxszhl8DOhZrHdfHrm/M2HWdJEu0BzB0BM6nnM4vAYU+lJhvBC0q1pCJKAxm
UUyJGIjOk1pS2MVqEYaeVACy1l3UHho/78Q7kg+nMhucK9htlMwqi2esrjrFT3/V/WD+VGLe
+8ffPuGl7Pbh6f7uCqrqDkLqsic/xKMwnHtaIRUqXdCG2fuMjv9QE+IsZPjHhmGgf13UmM8A
LSC6FazDgggmOvvIPNiY35dMP+C1K37HD29/fCqePkU4Mj6bA1YRF9FB84/bSW+9HARI/mW+
dKH1l+U4FR+PsmxLDtcI86MI6ZM4Gh2CcwJxniHF6zGiezGiuv3vZzhKb+He/Si/cvWb2vSj
0sKeZ/nlOMFwh8m1KekYR8V4VlM2mIGogF0X2P0YMDh0U6U72cJcJ2p42N4ZHtWqmpPpnQYC
zqpzYqZaHb+XRShdLgJzzzpVjGRE03ZVxLt5cFAqMirfZ0wc6VFpckZ6hvUEexC10n1EFj7v
V/MZSDOUeKyNabvPopoegJid0/yjia+bZpvHez79mVPeOBxBYlCQD2dU8uCBBGV5YvhA5qag
TUoPh7yJTLax5phljEf0CnWUpS4JnifTFBMJ7rTFHONtjOgbA/bGcgLRJcY7DJ5b/OHtO8FG
8F/qqRW3aXCVLSa3X5yK6yI333MhkEqGHPzdfo5W+iQZXpFeYnyuYnqQtSK7XX2p0jpxeH4S
RcCZfwderKl17YoS/c0vHYr6ziODe3fu3JEIEjgNPRn9LPqd/eJQ75NENLbHyQNDdikrYRiv
/kf9N7gqI371pzK8k1cESWZ275t8iqu/Awyf+LhivZKTnmqxA7SXTHrWiyM6YVgHtyTYJbvu
Qa9gZuPQHckRHRFxyE4J9bX+fmcMtEzK6AuoLvbEyrdzjaj4HjuHSAeiFPC5bvPKu7QtyEhE
l1enT+v5/vz9+VEPrRbMLtyZdA0fVUqfm5954hrrEOoIEb3LriziNl+WUf5nrNayoUr48WJY
TCVsz3bARIQNjSwAyPOHpCaBaK0XsFCMLE86PoN7MzmBOtGeNkEYIzNwSU111U97HAZh08Zl
YeaKGcGoraO0jyfObzrF2+jls+MYKkgtjyPLa/1kq9M9t9J1SxDICNrNE0Z4uwjEcqbBpJjT
Cj0rJxwhWSEwKya+TZVGulIygnvKImz5/qBHEOjQ8RU26M3aooi0aAVR6db+sk0zI72MVMNF
BUgRSUanWZQUuMMrUo/HylhsN7OAZYa6JBVZsJ3NKDu2QgWamwJcf0WBrzsBRvkvjEFtHWp3
nK/XVEqwnkC2YzvTQzt4tFqEhqwQi/lqE1BTjQEgx5OZG9y6Do21XNpGZtz2+xiN9j/TuNe5
J4h4n+gnF5qvqloYVpoosLmWOhcTYP/cMHX2C0piYKkFS7LZHd6NpzfxnDWrzTrUFqqCbxdR
s3KgcHdvN9tjmZiN77BJMp/NaCOv1Y9hBe/WIBPbjFBBvT6JIxZ2sjjxQRHWRfD/fft2lT69
vb/+9adMKv/24/YVrnjvqJrEr1894sl9B8zm4QX/NMP7/9+l3dWbpWLh4UmdN4mojTyjfZ5E
40QZgC2nTZQjQd3QFGdl5TrziHLHOiT55ZtpQIHfY6IlFY5eJRH6q9+MGp0kOuohChFvz9f2
77bWY1XkimdZhBHJukfTsBMs1ym2YzlrmQbCt2lMU965ZHlKnyzGOaJ0KpFI+/u9I1/KOB1e
aKJxxVK8q9b6+4VIZf7q0nqPH+hqVtn8/gVL5I//XL3fvtz/5yqKP8Hy11LV9Ge90J8kOlYK
VhOwAwHTc6LLBg2HjMHYEBOhBoTRgWySICsOB0t8lnCZtYTZyfvGPtf9vnizBlRg8id3CFuB
SS088CzdwX/cNgBKOlQJTksbiqoqVcXkmrAba3X+YqW3VTlYpFHEcnXuZ24BxwL8T64VqyvH
UjALBNTbxrTL93DBaBlY4pnHZ0IhWdR93SqURiCj0IrNgWBLalF69HZpNrYDuUzZrJifJ3vD
zydOqy/UfipRlKOehVHNwisszIY1tHAtsHIZq70ALQnoYCcOZ6Lc4nlyAaY3TTORkGagEaRW
SHW5rBdqTVvQAFc1nL74DJHUjhKlDLw1lKqGie3A0Sft28Rwn/biGHkX1xGP1dJqN9zXgFGY
Gh2JkDozKQJ5B+Km2tmjcKNzge6wKs8EpxW57l8zgIhIxI4xN4v5du7ujH33jq1PfaoyLwny
uFS40v4WxhPo9v4eyFTKYqPJxuNLCnTDw0W0gZ0VeDEys5hSyaD2QgZ/zX203T2hZgehvUVi
UeGykhSrpb1qRhruUZ5Jum9yGbSwLkkpXU5CtNiGf9ubFavfrpfOzFzi9Xzr5UhOglUJLflm
NqMMHxJrx1KqiuwjMz62VczsxQVQGVXjghNO0LLsxHQNDSVuaLy0ph/25nRqx+4W7X0IbH8S
ViyVChZNkuRqvtgur/61f3i9v8A//6buEfu0Si5pRd1sehSalG/0/k3WrXWIRcAQCkyILT16
aG6Vn7nb+KeXv969AlualydNRpI/gU/r7ycqGD7AnfDMcoZSOBV0d83JN8oViXpt+lrpugZ/
h0dMTviAT1T9dmsoKrpCxUkkICDYbenhLQgHp8aLFVGVJHnbfJnPguU0zc2X9WpjknwtbohP
J2cSqLaUNt4+W5sqcJ3c7AqmP3zYQ4A7lWGoX/FNzGajD7+F2xLDP5LU17uYLPytns9CivcY
FOuZp3AwX00WRpeca4ygWm1ColvZta9dSbldkJLVQIFWCbKoNH/j63tkVPpAVkdstdRfTdQx
m+V8Q2DUSqY6wjeLYEE2B1ELSqOj1dqsF+GW+l4kyDp5Wc0DimMPFCmnmgmCmpE8eUAUJdx5
CsORcMBhCtZN01D1CcbFSY8vHSehe1PJedZuLFsXF3ZhN2QHhdwneGma6iR827d+4MuygskV
wIO2Lk7RESBkJfUlW84WtOfDQNTg3pr6TFQVok0il3VKRuRRSXRcCN/88ORRlSQyUaQnDlMR
YP8Uo/Pz51QQrdtsUC5o2iKHnkx8gYHEsaQvSR1Blf5S5Kw9stL7gklHKfW9EdBhq73t3XE2
N/WdHSteNLMuP7i3LPQJb5tn+ZScGT7aE6jV3paXyuq4dag16/UqnKnxISaXAxMhOWvX15Ll
ZriegkvutUsS2olbo3HeB9Rwsns2htVwuWh3dU6c4tdN/ZU6QRS2Sg6YDreoujl0y2PCPRyx
D0a/21AjpVtTTyK74K3o1Msu9uxF+3C2WixgGk8TCw3INuGass5rg1gVIDLiGxD9OFuVxGwN
Yju1rC2y7SwMhmVi4C5wNsxxi7m1s7jJFpP7Kv0mgtWWloEHilWw8o9ixNlipl+vDLDpvN3V
GCewcNGHBP7aMWJUlGc4zi1s/IpNcY64Ogcr4DAfMwZJuQo/HmtJt+7p7NbLyDGZxpiYCxEF
654zaCpMni4t45UEqbEZmilhgu+IlknUfrawKgCIdI8uLHgQd/pvm34+dyCBDVnMnEbtF+QL
1grFXPIwdG4Rx9vXOxnYkH4urmwdpdkFwrZsUcifbbqZLQMbCP+2Hi2V4KjeBNF6bhm4EFNG
aSkow5RCZ+kO0HZ1FbvYoM6aoIjtb4iAe56rVWWrqCW+UmTQdVaK0unkKV+m9KeU4Ep26NSP
4lDkwHhim7qGiyU1Y8Olk7oTqpvsj9vX2+/vGMBmG4+VGWI0iNAixylPm+2mLesbaot2L6Ag
dhyUEagyxH0JwkHbkskANQxRwZCcwURw//pw++g6f6hYg+F1UnPcAbEJwhkJ1F+wd7zBdTrD
d0FHzFdhOGPtGSQdZgi7OtEe7UzXNC5y03obDSQfajOaptt9dETSsIrG5FV7kqESSwpbYcJP
nkyR9M+b0tVzlt+4UYM6hYzcQUs8rR4zJgizs/4UaUVmyzAquxip4UwUDa/qYLNpfP0ouMe7
3xiOehWu1x+SwQ4qjykp+ulk5luxxndSz3z02QXIz+4ivg7Wc4fz589Pn5AAIHLTSbOca/hT
NTG+Ax6azebuNhtRE0vd59TaoaWjIlFMwvtq/cUjGLP1fE7NYo+iKrFpuxuv/ztWFgcd2tbR
yY/RRsakMK7yI8xLj1s2S2tqiHvUx8M1UA5sYm5RwA1bEFxHgcdiAY33L4OOoOfj/iZ2hOaj
0N2MGgKbBvQPsuGM2wG/Ck4tONLtqUNKv59DkrsDM2C8bTjXm3Dmbh4F9pYqrGxNGvjjac7g
vEq/OXUqsPeTIoryxj0LFXii1HyVinVDbcEB5/H36DdLyndJFTOi9i4ykKi7jxn8cDA6MfBr
zQ64dl0uZuKnWBlN2e5u0BNwir90JbGUv6Hod0W2sEdMNI03AkQqZguOFhFIoR+0gVUR1fEq
+olxBiLgD0o4sNlKVQZOtwA2MpSFzVEwWCAru/GwGzQif4q7w72b1Bn2+LKKqdVboprvo25L
R3x3V0j3/In5Oie70wdzUeiphEaYdyfCDiK+BNCfYBhwJpBLr0dIoyg9tQOJ3tshjsiQ6u2z
P6qrzNH4d8hc+eTEtIdHXvxS6PHm+SnLTK+q4zlyYuu7qmUu4ZMrasl4fWwSVGReWQGAWbty
PYhjhLXKPWa44SjbqjtP+BQgXKDzODMUfAjFJ5CU6s9CyCRCXR7ZUX0iMejhpRTxlOZE1pqg
L610hav2Zm51ROuOBAog0r0FuuCzrHFxsJuF6hbjKSgJvo5Eu+Pmi36ixNSgiJEkOzL2Ji9B
VgVurpMRtezqqUoAtaP6PNRyvPjfbWZlmZniAr+ws1Ec8xUmVFn5WpShdGGXbvHRTrPJ2eOF
fyzNPPH4W+bTpGhZflDvX/fv5I1W8Qgf26OaWidZZAaUN2mW3RjboYdIn159O7uqBL3LOLBt
XZ2A3aJrmEq44RqvQRJwbdaB/UwoQIjHCBEqzS8Y+2HsiKB/bI1aF4jEB2AMOy8AuTQ1K+/6
vx7fH14e7/+GzmETZXgl4RCAxVi1U1odqDTLkvzgMfeoLziBVg6aGxbvDpzV0XIxW7mIMmLb
cDn3If4mEGmObM1FwPDag4hgnjVRmVn+Fr336NQ4mVV1aVlQ0+PpvuBq3Q0Lgz3+/vz68P7j
zzdjbYD8dCiMbLU9sIz2FNDwN7EqHj42qNMwm8Y41V0+qStoHMB/PL+9Tyb/Ux9N5+EitMdS
glek23+PbRZW83m8DlcUrBXLzSZwMJv5fO4AQdKzKI9pEx5jC5huZFiG0eZU2GFdBpL79leZ
ps3S2ZHy7VBvdbCHqygJ/PhzGqcMNgj1hqZcP6kIw60z7gBeLUgbnUJuV41d5JyS9hSFKaui
X6Ty2U0i0lzWHJnumyO7++ft/f7Pq18xaUsX2/6vP2FdPf5zdf/nr/d3d/d3V587qk/PT58w
6P3fDtORJ6BvLdVbZyYR1opMPRYDGzHFJyoZHdci6ZvGOwhw2Qo2i9BixBGHI7fS80v34Osi
ZxYU/VDrnQmM8JCx5T9EELG8OjYR6SGX/pB2cISFlt3/uJbeqd9snUawYzd1xdLMS2BoaiUu
PYA0kekGHwQnh2BW2w1OeHL27wJvnK7a14cjXOtj2qwsCYTVspQfbECDT4Gbpi+JKMqFx1Ea
0V9/Wa5JB0dEXie81FNYy7Ol0/XpoHoVNvbpV69XgX2+nVdLy0NcghvSaoi8QwmUZi2F5Qwj
YUawpoRcrHmG88SzREoOq7q0W1XmlIuTxDTMIW6Yu0wNChWW5t0Num7KKFelKSklI6taRMFS
1+hK4LHlcMoaNxbJMHmdWHu8uzHrkNr+DRfgvXMiKPDa16xTvoK7RXCxlqy4yb+dQJa3NpNS
su5K7szAhMJdR7eW8ECkvkXwhVud61LXOstRRbR5J7LJPM+LSFy5ndhrmBfYOVuSv0EUf4L7
NVB8VuLK7d3ty7tPTKkZuiydh7j74v2HkuK6wtoBZRbsBEKLeSsHKExD3bu8aAIXKVwZc5qx
s73S1GElg+EoDIYPwtRZk6G83E3d8AhHedA9IBDjy62mX1CG+hbaBojiXCCkS3tl3BAvGoJW
SZ2jj0h4ivcfoDn6/PDJh7TNBHz4C3Xa6ql1pkcXHPUT4SgDecYblXINEKmVamUEPz5g4J+W
3h7jp46mz0hZCmexlnUJhZ+//2GL2smTfL+kPN5k6U6+bZ4n9aWorjHzkbzaippxTNJ09f4M
9d1fwbKFhX4nM67B6pe1vv2vHqjofqxvrnMXAoBx/0IC+GsE9JkTHUT3dhhRoVQiMf2pxB7I
ozJYiNnGvPHaWBcjmnk4a1y4K5j0mOiYVNXNOU0uLi67yRvrKdYeJcMmic5kMb7Kc21GGfaN
qIqG9g8bGsPyvMh95aMkZphdnnaJ7KniJAf+PP2dJLs+oonL86GE87QWu1Pleeq+IzskPM1T
rGTiU2mUdJ+xEF9RUveOFcL3aZJRkvxAk1xS2UpiHZzyKhWJZ/Lq9DB82UIpycMFBmFDNRMx
a0qKGZaqaUTrwd/ifdCQHt5DD6LNfEMtZRHzzTIkFisaV1BA7blTdf90/3b7dvXy8PT9/fWR
zPLcla1g79LhZ8NXj225J7aigveXExeJ7x47V5dh9PZTQr1OVW3Yer3dhj9JSDl9EdXNiKnu
sevtBHI783VHoUnPV4JsPlnNmsqz7NaymG4L5SjvUq3C6Vr+j7EraY7cVtJ/RacJv5hwmAA3
8DAHblVFi6xik6wSuy8KTbdsK0YtdUjqefb8+kECXLAkKF205JfEkkgAiS0zwu+BI4zkg4wf
bXT20ZzjjzKmH2qdYLON/fRDOhbEWzoWbAs9+KCIAmzrzOYKtkqSb5azJFtouq3GQfa+SvSH
mKKOP0ymyFELgTm6LMdi6mxNgb4vaWBDL5OaTGHsLgVzNrhAo4+Uwk/f13NRJ/9jbO/XafTV
VYtrWpli6X17uBvu/weZdKakS3BwIr28KaGkHF9ZsykclSATdN4HcU2QSVEAvgtgLiBRdoBh
8tLuzE0E4d8GnChNLq5CQlUOI1zP/FHVfdKdrUnr2JwhRQrCZwDaiPJUxfAUpWJWzB55p99w
Uy6I4v2Vtx7wSCdg3+9+/Lj/diU21aw2lPVrCtXRkKQNBzFvGgWdbpi5q1LcGO7CVXC6xKl/
saw2EN97Oifs7LmS1t6mS2lkLOrj0cqvacW7GFdCzWjKuhl7KxFuLbrLaW5daJpQnUYjfWVv
RSVfRhaGVsYijtFt7xQxnIXs8oPeJ516INepfLX464TCPWtDU/T8dzFhbKP9q4Fhe12y7vnB
7hn5wTcUSpONcNlrSOamOmYn1WWnpPYkygOm1nyzZsthhaDe//2DL8SRvmE/WFXp5l1euzt6
tgICnW7IUBxr+k6ZCDg2hSKfAlm61VY5ZcQuxNAHiekLWdkOMmQix5Nd8QFZUTuv6eGcqz7S
bZn1lXxv5PrI3G0XxLr1k8C3iCz2Tbks04/dNHFEMatSwUNT9l0eDiEzM+5rynK7kEPb8xRY
ZDcJAAlxZg44C6yGHz41I4tMonx9ZlDPeUYCuzuJx1s2MUkCbRixm38JRLStFuaZrXwaOLDR
apV6zHYYjVpEPuAfrB5gU6pbEa6G2NIW8agEiNpNsl2L3KfTVWslUBImhcvDy9vPu8fNaXa/
59P29FpTq80pl7Hjl1zQ1OZvRIgRkSn59d8P04Zzc/f6ZozXN2TacxXPvU/YeLKyFD0NmPaW
R/l8xE5V1G/JjbJ9vQL6XsJK7/eVWlukGmr1+se7/703azbtjx9Kh8GwsPT4BaYFh4p7oVFx
BWLbyQMPwe1zPR0sxJ3GQX1NVAvAvBAHArV/6wBxAY48OHCb6xdhdRjbv1A5tK1aFYiZo5Ax
cxSSlV7gQkiM6M2kH4v5Dxf1uIHcq05MFaI4mNeP6020HzRXkCp8ysv6NMh/sOWWwiouiKj3
BtEEu1JEUMBXeArfHL/wnUw780BTBeXTUBOD6NT1Z5xqe9rRUOFmFi96kUpWvGvI98IQu+qM
vzmaOKwkJljEhRLgWm44k9nD9StuhniRol1ZOvBR5zNfxw0sCcLURvIb6qmLzpkOehp5OJ1p
ho6GYBt1GgO1k+yz3q6KRmzSY2oR58+zT9C0I1akCTJfJDj5DgX+PG2pgWWYYSwE3TmdGbgh
RWIvQEQ7IYiEBEL1l0+zoOb38kiWMwv/nCXq8+UZAAORxjZdn73WZEQrYIWoBz9CA2+sDHlA
IlpjqY4kCGOkFLbJqSMJUiPekgEJRweQIGkBQEMkewBi3TpXoJDnslFf4GD6DrsKuTaEVZ7I
cUVg6SFN5gfYinNmkOZ2gnbWfXrel9AqNAnwnc2Fc3IDs6HS3RB6PtIY3cDHnNCmi9sE5z5r
C0w+MFT7W7qUFUmShAE2ysEYqK2alzHmbF0QX/KTEHbpWnclLv69vajPMyVpupUgt8Tkq8u7
N265Yi+cJ6fNWTWc9+dOe0xoQD6CFXFAAgedYfSGeOr1Kh3QdFuH8F1cnQfzNqJx+I6cidrb
FSCh+nnFCg28fptOsAUHcX4c4S4GFI7YnXOMn9gtPIeB4L154eh9x7nOypHDPbitQo4QbkC8
kuUrmhor7DUbSpdb2JmFeCaPwbFLGxIeTANjdTbe1mWvOf6bka4Rl2JdSIshfaa7hlzocP0V
bY9hbLekBIEZ28tgJzkBt2nNi9NjSef8R1rxwantHN4eDca2x64qz1xFH2Ge3sERO9Yhi7Ku
+YjeIIh0PpMWiNCr8BoeZmPVAad+Y7jV0DHh66udnajY56S7PYaEfhyi0tv1+aFBPajODANf
/56HdNBikE7gvg4J65HKc4B6KMCN0xQrCAe2+vqhOkTERxqmypq0RDLi9LYcsZwqZ0g1RVPK
d7obbBrbmf6e665VJJX3yY5QTKsgaiY3zRBATPChC0CyngD9zpIGJlgBBICUWdh9ITowA0TJ
9tgqeBwHmxpPsKXqgiPCi80BpDuCUUpjrNSARF60lZ1gIYnz6wjfWFF5EsyuUxh8EmNKDCEM
0OFFAH7iADBlE0DoyiNxyYYXLNmaqJu89aVFYn095FGI7UcueNtTn6Gt1cV8mEDspbqJfFT1
mhhbLykw1mUazGzhVIZn4TDxFQZ880xheKdzNOiB0wonqE3D6e90qCbZlk4SUh+xQgUQIO0j
AUSkbc5iH+uYAAQUEfdxyOXWZ9Vru8kLng+8f6GNDlAcb3VczhEzjzo+5oq9pZ7rIwTr41Oe
37bMuQuxVnrHwsRxz6QxrjCb395ArJqjLZCOG1MZ3A5tq2U9YxsL03nNRgZ9NvSICddz4xdp
WE7GOzkH/L83pcA5gr+3CnIYcjxp+UBsM/GiKfnI6XLiI3nKJicBeo9H4aAEG284EMF+GiKQ
ps+DuNlAsNlTYpmfID2BG1ywRQAvYV2tChx0a4gQHH6EJD4MfRyipW2iCGlwbp4SygpG0MEw
LfqYUWwnfeHgkmO4ylTHlHpba01gwDseR3xK8R61TjuoF8kFPjQ5Ng0OTUs8pMkEHR1/BLIl
A84QYLoDdMeU2bQh2dLUS5XyBc0ZjFA7XQ5GLEoRYCCUIAW5DIxia/ob5sexv8dKCBAjWwML
cMgABRhAXQDS+wQd0U1Jh+FxuryPlbKOWYjHhNF4oiOyLuIQ72cHZC0lkRKFjLPnmS6uufzX
O09Ql24Dz+ddJwUL03DtEfUBmJhA09oiQDCmoep1v5szVjZlx4sGnv6mcx1YtKafb5t+DYg0
Mxs7ZzMZIl6Cu+Pboav0KPMzxxy1YX+C6D9le3tT9djWHMa/g1W5cEn3XsrgixFWyOiu3/zB
+0l+tJDAl6XHvfjhSmizTEV52XXlJ6XlrDTKBhz8Vo5DqZnLGcvi2p95kOy7U34topZamgMX
vmxqM1wrxMmv/tv9I7zmefmOuX6UEbzA82wx8HH71O/MV14ag5G46Cacww+8EcljqeTEgtV0
OVrdTEsvDfhqsuouoSEHHxWneg4ktXjuxKQgipi9PN99+/r83S2j6XzWzhJeYR97nN53mtJM
5XBm5ggc5yzTUIk2wfSywsU8wfAUd0vlAA/sKgE5tMlFl/IlIFbT9+siXZLefX/9+fQnqjyz
fyMHi+D59PPukcsTa70lASePMq6DG6otsV0f0gKiIeVnsRvslp/ty2emGB1rIR9PN+nnkxpO
ZIGkHyMZBKw8wgheIFwQgUC84YNElIjJC4N1F1hI5+bu7etf357/vGpf7t8evt8//3y72j9z
wTw9q5q2pNJ25ZQJjJtIOXQGPg1qeuliOxoBXN9hb1MtEBPGps44M7teY1eYkf60G9QWXPVD
BZS8sClD7hvbeiCAEE0eoMhfIFQDBQ9FeebRvzzuKMmaHM3jpkh5FQqsyNPNB+yrKX7oRq5f
qqqD2zJ2hefVLQKlvPcU6a0P7qgQdEhI1yTU8xxgnzYJ9iGnp2ERIMgUQh2t427gYgEHqxu1
nB7zY816gyYqo7BsJSncTNrptccx8DyGKpBw2IEg3IjohgotR3cMh4iwzbqdjyOW6uwvzEbm
SANoV+GLI1+EJRzyrVz5QpeOuNLBVqdLeCqTuDi7lUfVjBR0XrESmjE+1+1EXKUEQRi2utZp
BO97WlLSM4ItHOErwkhfetrdj1m23YGBC5VIWVTpUF6/M0TM/lC22eo2J2xbN6c3nXqFZ2L3
JdXok984VBlgXt3I51L1/C+H6qb5pzPE/jIGrRWHaIxDyY1BJ0ddNeA0yjHuARwTj5itVWbc
iPRZ4ExXnOExq2RLpUPCh64hV+7y7MtTUZr59HkI+uvIpOel2FVDm28O+uW5O80yUNQ8iz3P
zA6O2npswXqT7vgaSE8g8j2v7DODWsLOl07i1UQol/JYnOSlvZPuXRRO3gjdOWQHqJ7coUWV
49Byrtvj7NKxOuK6Li/tuxoqJ3QR0zz8wg448XXi8aK35nRL2xRw5EnpYHdo2nOopwl7jPNb
FBvx4yw2JSGv3es02GjSCPOeiEVlcWwTk5WoDKz54cumVpbtyPvH5sC7BIbW5Vglnm+JjVto
sQdTlCNLvpwKYluyKi6cYTlEDx7aPZ+Z88C+LXKr6i30SHeXFB6SIgtf7a/blBI9o3NTq/o7
v1/49b/vXu+/rRZpfvfyTTFEITxHjiwlikEPV8A7aHvq+yrTXNX2mc7S685exFd5JeIZo1/P
qE6UvjYBE+7A8S91JhTTLzny1kmRtIBsMMny5pWDe8HVBl0BvlrGdSNVymykOAGNFnJVFlhE
mzWIR4w4V5r3qtu8OTpQWyTzLejVceYfP5++gjeWOQCJtSfQ7ApjjSko1lsnoMpYKvs2LTCx
AAdcnlI3o6WPG/u9leBNB8piz4oQqrKAp7xzr/k/BjqvbJh4+jGCoBdJGJPm5oJ3REhxbKnn
8nouaj45T9JckgJgP8VaqVvpmQ+FF6KPEZkldPk8GDumX1Gqp5T2Va77aIBmgLUg+lpvQUMj
nWlVajigWxD89G6GI/zceoGxk5AJNKLNARVek15nfoJ6jxQM4+fjqZc+SaxGyom/dbNc8LQ0
0i9J6vDI0+7cis/XDCFfnWgXvw58LdPObaHQeDG053bwvZz7Pp3T7nrxLahWA8IbVWiMPkCM
F6vr9is0rXOmnRnAG+iNFnrMRPmkN1SmVCUbhEYRJxtO0Sl8Leorb2Vqm8HKBWKq4XerAf49
PX7hQyS35TBXtsBhvsAEmoy16GFEq/8JMjfSXA1v3YifqGKdiVFDlKo+jVypuquVhc5QBxwT
zBIvRr5iCXV3WIEn+FH7imPnoQIdInkxRP+GU7eSnDeenBzHYSxd/Q3W3rrA5qcVqlU+BSeU
vXIdDWe6w//z9PwUmRZlNEudtj6+VInGJXtBM1/fiim1zJF8+iqIoxEFuDKXsmOod/4EZr3j
FdQm1H0JL0S3/1LBcv2ZccXGrmem2Rii4pm8RHZ5Y9A/w4Jdpw0QVN33w5GPmrk2bAK6vJDW
ygQvYBh+H29KsnaEoRSNl9YN6nEKnl4QT32HIh9j6M/RJQ11vSUyX59LW9TEs6n6C+m5+PMb
cL1ekAiLNnNOiNX/JjrdME44Cx8G1VsC8yad3bgzkp4LfWriQOQFm3bcTU1o7Fs+gUWbNn7o
43frpFDmCDRuFrHCdeQ8e6dQrSP5zB8l2r1KGFg00Ik3TUj0q2cz1fG4QMLmEGuCzE6RBZ7L
4jHvJKw0zGIDJPQ2dGF5Sa923OEmYMRSSBlDpW5FdANHcpJHcPRmos3OSpKvWkVsUnf51sM0
o+Xmd0RGzGdxvtC3llrqDvNd66Nl02YOxaslvcTnFQsudCt05thVY8nV8FQP8s43kghEJTmn
MnzMGZfoygw3D8TFg4Vd2WFauLjRsmfR6IB022eF4OEpUy+MKVAR+glDkSP/1eI1m3tVXZzw
e102K7c4Yf9vUwbmKnNFsIWh0louVx0aCyWocARC8IR36ZEvlx0LIoONoZ65VybT8l+Rqq/5
+ge7E6vxRDQmKVYDmFRjRw0Eti0a8f4UVSlAdB9ACjbkfsjwhZXOFcXYIL7yKJY2kgKgIToN
aDyGVW5ioQtjUZA4Id321UGGXs/WeaTBjkPqmtwsrWptmJh6587AmOdOk1E8zZaxEBcAR/CB
Bux/vJcKxKEvci2xLTLOwtCGarMq7VEgT5MAb1xl3YAUp73w/upwRWlwOZ4QGFzoTs7KI84B
u7Y5YEUVYN8UwODGpbdpJH8Bn/vs9mJ52LZ41Zvow+mcH/q8K2GrehiqIx5kXPlYrnQ2K9oN
AfNQ7VjWTljKQ0TebQ3OZDwxQpmaC30vpZ42beq9N3UBV0/e5QobFkeY/afwiNfUmFD6eg/n
g6gGS1MrO50mp+cOhktX7rLzzs3Q3ji+Fkbg7aVRn5IqOF8oehE643CI0cAxGwswxpxGrzx8
gRKSyEfHK2XZhqQOKPXf1RW5QHN4rjTZ0MWfyYQPytjzfgMlPr5jarAljiWGxiZWdduFNT1v
rdCysEDSlquEdwogBpo6zaoswzlz12Ixt7ZDgHI8DdWu0p1ZiMsNAp2Oi9GzNeBBjpM1gJvo
tdPj/8SYFd1FxMvqy7rMtbxWL6TzGuLtnx9qLPeppGkDBwVrYTSUG9H1iS+lLy4GuKUxQERW
J0eXFiLcPQr2ReeCZn+WLly4sFFlqLpQ1ausiOLr88s9FqXtUhXl6Rb3IzoJ6iTezGuRGItL
tm4eaPlr+Wj5L4HBnn/AAs9ukCUfSB5L2UpBpF88/Pnwdvd4NVzslKGcEI+Tr1TbARa+JFIu
2nCw+HxMYU+9qY6nDtuLEkwlxHrruZ5Vp+NtfQIn69qVLs5zrkvF59FUcKRoqnbaV6wnDcir
jU50CepVR+TRo3bAIlt0uiqH3zDi5TVTwC5WcB3dygiSEcqIJGFqpeUh+Oru6evD4+Pdyz/I
EajU8/NRqJyUz8/Xt+fvD/93D7J8+/nk4p82ZK0+I7ChSAlEc7dHngVnNHFsGJl8+MajlVtM
nGVJmPp6XQPLNIwj15cCdHzZDNQ8hjVQ1Ja3mPyNJGiE+zcx2IiPW2Aq26eBeKhrEpVpzKlH
GV7fMQ81I0zHAifWjDX/MOy30NgeeiWaBwGf0H0Hmo6U6L70ba0g6MmNwrbLPY84FEBgdANz
lGzKmjqblrGuj7jIHNdm1KTOaeI57HC9N1ISOo6cFLZqSIjvOFNU2DpGP1A23ni+R7rdOxL+
1JCCcGkFDkkKPOPS0JyZYuOQOkC93l/xYfFq98InK/7JEhBI7G2+vt09fbt7+Xb1y+vd2/3j
48Pb/b+u/lBYlYG1HzKPW3b6JMOJEdE9A0vyhVuy2LPfBSXYRxEhW19FmvNVMZXyfqEetwka
Y0Xvy1ebWFW/iphF/3n1dv/ycv/6BlGu9Urr83E3XjtKNI+nOS0KQyzV1OPUYh0ZC2KKEZeS
ctKv/UcaIx9pQGwRCjLFltUis8EnRv5fat566ovhlZhY7RMeSIB6FJ4blerupWcF8Rx+VZbP
Euw5sKISuHq5SgKToaeeos5t5Wkrr5lVcxgCxEvZkzExv5+GhWJaYus2hwBlm7iEL7Ma7U9T
6ECOj2SSRqElMUaI6r7lrIZm7xh6PncZfLy7aPOSUJaMRanubXiVY0ys9Q2o7nD1i7NTqcVq
uZ0xWuWnsVkGSTRUVqihbxB5LzW6YB0FmmPWtfCB1QjHcTCVVO82ITU/gT7ih67GLqoMJKq7
clIB/ErDxBEDhztlgFuj+lWWWC041Zbp1HSXaPMx0MqcmB9DF/Oj2Cx/PhaUz3mO0OgzQ0Bc
wdM5RzfUlKGXtFbUErcYUDETRbRFQfj8CouiU6GOpPk01jsVEXo6o3Z3FoJD3bcpsG8LjArH
DvIJ69Dz7I98zfnXVfr9/uXh693Tb9d8KXr3dDWsfeS3XExGxXDZmIK4elIPvV4E6KkL9ef9
M5GYnSTLGz8kRkPX+2LwfW9EqaEpmokeYS7wJc7byVQl6LCeYTikZxZSitFuuTDQqcexfzqZ
AZHuBUc+Uu6L7UFJzyRxNjnvXwwfIam3BkGH3PTZ+z/eL4KqWDkcPlq6L2yEQLdGtX0GJe2r
56fHfyYz8Le2rvUMOAGfunj9+KDunqUVLn01Kh/blvm8FzLt9rxe/fH8Iq0ZxJ7yk/Hz7y4F
OmYHaqsdUF1GAgdb3Z/GQsWOKwGEM9DAMww0QaQEIxp9HRblvtlheravkf7CyQ7HryKlIePm
qr8h+SKNohB3sSPKN9LQC/HbzJMx3PEZf8MCgwkBdTcM4OHUnXs/NauV9vlpoO69nENZl7qD
b6kGz9+/Pz+JV/Mvf9x9vb/6pTyGHqXkX+pemrX7Ms8rnrX6aCmyFLJWPPIR/PPz4ytEIeUa
ev/4/OPq6f7fG1b/uWk+3+4c10Ic20Uikf3L3Y+/Hr6+Ylub6R67tXDZp3qQ14kg9gn37Vns
ESpQf1MNECH0pNzthzjgVXu++MbeeNFpoR4L2Ddr+UA7Cne5+CarYBIucBv7Y0Hvy3oH+2yO
j6+bHjSgNeLrLp/zEjT98P+UXVlz4ziS/iuOedjoftgNkbo3Yh4gEpLQ5lUkJVH1wvC43VWO
dtsVLlf0zL/fTIAHjgRVG9GHlV8ycQMJIJHZ1nmRJ/nh2pbcE1IKP9nvIJe0NwyNK8lZ3MJe
OW73okwxrLtRB5hkpAfCRlpdpybhXLJ0zLjJSdIPPG3lSxACw0rwYfhddUw5LbWCxh30GLR2
enp9fPsdD5nf774+vXyDvx6/Pn/TBwh8JcM6H0E3XJnSVBjwJFgt7MaQodabQh78bTekemFz
dSeVWngdX96UElSm/YKgO07QyWaWShZzbxuzNIbRYJdCUVsynpaGR+LerJeOjsZSRT2c6rKo
uPuF/fj9+Q0mq+L9DbL4/e39V/jx+sfzlx/vD3hmblY8xqmCz/SK+Tkp3Rr+/dvLw3/u+OuX
59enW+nEkVMIoME/GVEtiBzjiPYgrPHQVSdH6j0vM56QycKifyo56ARVkbCreccwUaQxB8eK
oSBv7rL8dOaMNtaVHXPrcTaqRt+uz5qnX5wP3B7+92llUdLLYd9QNJiWIt1eWY7q1PRVLmuq
qu2WSQ/sEPrWY8A/NZT/D0R2eXSsbHFoGoix5wrKezEyFEyFeDe6W/Hw+vRiDEoLMdItRXyw
JlQpdUQM4eP6vnt//v3LkzVTqZtM0cAfzdoInWSgcUF1Kle2MVmljTPLwcpYsJIlCXbkyS6B
rPXZKigSk3hndYJ57LRDRN95I8brjJ2FR0kDPBIlqFntJ556GzEJTMtCmeQub+TdmlcwtNK+
zCv6iFqum/zAIl99qDbOS8GzWi6+LT6cvx82PPv3h7+e7v71448/YNqPh3m+k7AHpS2N0ZXx
WHdAkzf1V52k/d2t3XIlN76K9SkIJcO/e5EkJY9qB4jy4gpSmAOIlB34LhHmJ9W1omUhQMpC
QJc1VCnmCvQvcchansWCUUtZn2Kuv/7EIvI9L0set/qbTWQGnc+I9Qk0DDeTiMPRzG+KvgCU
RmGKrkUis1or91Vu4319eP/974d34vEn1pzsnYbAIg3t31CF+xwHGFAzp1W6aJsGUQ1Wjem6
42VoHa/qdOwFZE8GJlZ6oUhd43u/BO0IWsrjkQGzWdWUpgsQtIx5QrqXZ0p0QE3s+9YZxogc
D2YPO+y4/bsFffGfC73Sz6XZCuiwCdV/s62qIJZvG81RCPOGYATJfN4wkntLAgegu2Ipzswh
2I8OerLPRL7H6SSEFQ0bSAnfzJZr+vkPjg9f8DhMSGqeZpYlyamQjqxnyiiRgifKxOprEG6s
zxRxlOrtrTU1W2Mzz81WnztzZsXO1gODgeh5VDHiLIpMt1sICXrXhoNA+McAz2HmFJ7k7q9l
biUzj/eeNjvneZzngVHIc71ZhWZV1KCkwApmV3hJXevJucz8PILtir2IdTT0Uwer+9n0lGeA
0amqc+owH6Rc0s3SPGKVxBr2h20JywP9lXT5Yk4O0glM0hDEA00066xoYBqzO+SFvpXCdj+2
KjRbm0SxPaDrlHwwKXukzQuUbp9R8gP6EqXs/ZCve6Cojf0dqNtNvTD0bSxfF9zISihmG88Z
nOyr8m2Nd9LgMGlkeerJGx4Ch9bk2tGk1dTBGoQ9Zs8quzJncXXk3FJBLOMhWRtrw9YiLaRa
61JIOzkE94YtG6nFKReWD49/vjx/+fpx91930NS9Jd94sNXJBAxWeFZh2JOziLTsItIbbI3U
YZLzfDXi93UcLg3LnxHzPtUZWWR4G/pr5U0r4ZQr45GrYkdWMipn9tM6LVHXl4UBbjakwZPF
s/YImAgPNzIl6Xxl3t9rAhh6UKLub7QcWK+nRsTyKDKmeIYir5OCwnbxKtCfr2jplFETZZne
G2/0uV4GaF7o3FjrNHIjRGvAx1iPYwS7S9NvAvzGiCunBqa1jN5LaTxS57vFFCWnOgytDWFX
QueAuM9YlZ/0UODyZ4umnZbLG4OOTiNhFAndD48hJYvVE0uTVESpQ2h5ErtEwaPtcmPS45Tx
7IBrnCPneIl5YZIq/skZ4kgv2SUFFdIkwrCEEkHh8v0eD3VN9DfoOi6lFVkh/XOeTQzqCM+N
TWIqGl4ipPeBvrBApsxOO5SoR9Na10qJNagLxNU/56GZVG9WDqsVzFHU8RtynXm5yytsYZHV
93Z2fQqm/FJFJ3Yara0OxvMOWeF10hr+X7smO6GxbmmnKtsS70Y8KQ8fdjVsfYrtDfqS0sYI
zPeF04oIwcLtfpMWp8UsaE+GQyDZGYpk3hr7aJ2KAk3k3LjcLNquoYfG5jNiWbl+m2XZeaxc
sjjYbLa2EJagHY5HBkvEcmGEcMikG59jYcuuhWgKR7akyiMCShuVLKfNRrcO6GkhQZvPnAQu
ZJwuRD7X83loTSG7WpkAGTIksc2hJqMkj+7JWVb2WTYLZp6QhgingnYjI1u8uR54RvQESbfG
RrUIN4FDWzVOzhUVNjeXNq7IAGFZ7zKr945gjMFmb7VizMqE2TV/kLEzTFrCri6j+nph51J+
T0bHGAQtrOFkuEFQ8yezxfLomM99c5HIYnGwyqtodi0oavwbzdvQzBYZZopgdh+QRHeMd4At
I6uC+XpGEW3BVbCdb5zqACppq4TgPt2YzlbkounvMwhZSywspIGxBRiIdutJl0mbxhmrPZ0O
OI8c93l5CMLAN6STPLG6RdKsFqsFd1ZV0BQq2ISQQU3UauzM1FkaLlcmqYiao7WclaKoRWyr
FCmfhw5puyJIpkmfXFPyTERnseO+aZw4SJArhWCb0LO/1PDJuVduQvPKGhHnJgyt4lzTvVpN
5A7tGP+3vGbUXI3LPmM1DhBaDENSgqYCa33lorJHuN2SKX3OWzTkAP1TEiaZlIa24zdkFeia
Ul7m0xFQOja5BEPCLKm5oxiNDOoq6aacShxSpopP4md3xhtB3FvcTGE4QfcIASJvfEfQFiub
BXToXIdt7vRwG59YqzRW+QbBVzmVmM+WC293cwEZbQaPFXnvUH8MN2P0Rlm1aLoAQ66FOYSz
VN8oDl3fzVfJ3WShpF2/okqSFtACtlKKEG9qj8ACux9oKZDDz9wsgsp+dkxqYjqWOVFECpW7
uwu6p2aRrdkVDQbGclWXKo8cgtJVdydbCQeknwkmdnHI1u/EXKQ33KEStfMsqY5ir4gyCLII
iRR6sCpisSfgweSCAKLPoP6sw2CbNtvNfLmWjofduX5gLuvlarGUXN7xpyXqC3encZU8y4Vv
/mJ1qlwn2lp72ntUjL1QnDIfVFXerwCaEoqwEmxtGLaBwlm6PaA/8XSz9jygMwXiA3A6tKIt
tll2Un15k+eD1t50F6UhtKvEyc4TXQ+ZO9vCZ9L5P3zSXo6iqhOPjbpU4VSUBcu5r7X/hnUj
k7fVINK1iX2L7pQFEFrC7t+fnr4/Prw83UXFaXiC1ZlDjqzdk1zik/81V3gs5r5KYP9XEkMf
kYoJqs8jlH7yKTiD2BNMvc4eZxBNGgwZHPSwRYirjFHZEtFe2Nv8/it/QZvoXNIIlCI81g0N
lkVaHVxIWotEqTvSelDu3m59PQFj1Z7svUzadBOC1XW6E0KrPzz/T9rc/esNPXsT3UIKo+u/
T59uWkQntJmepS/bGEdpqqcbxQwxXvcqDGbduDV3HKK8v+R57PGoPWbhQGf+IOULyuLCZjKC
IungYCekOMhUZN1a6UwwWsF8SM4CZiNYfaBfoQ5QZhjdjk1WglIVlA1tws+27mrw+KCI1YUN
gkRW5yk0016ExM3NBJN7yOVj7JQEtypUju+vCbunbttsPme/MoKsoO/zTK773c9wHRLqotiq
y8zbAtHeD6Wg5E6BCaHiGLXU7lkqEkIRM7lAX5XTVn90Ock8BKAldLs+AANu03xy7jlPd8yb
J582plAZNXGPFmdxcgWFPTu0GUu9O/LxwyOrLjwZxJM8u/gitb3l7EYu5GXsIO5m2rtrHZVK
j5xNZ2BgXAaTjBFem1Uqt+vwRm51ZkKRnfwmZaAkz7YzdC37MxnK5IHw4lYpJX/UhLN12PwU
r9TY57eapWPm1WYerH66beQ3Wa72q1OZgSkFKjHcrG5yyWpIQlBCq3QBTfTzH8gKh10J83yC
oTZ3dXSuhhcADBdYXRNgf728fXl+vPv28vABv//6bioBKtoTEydTeEduDtJQzzmmG9Eyjn17
l5GrzoHLl0Adp2gGCbOEcwllMsnlbs8i7s8OsHnXdIPLWdRHVN2Y4lWcPx25WtOR9whGkfkl
FbHvkE/xYD7aUy0S+7pQobKXHpITp9BDYxbGZQhCBo3DyEsqgwVVvZoyrBp6ouSut7POD2P/
tuF2d7RSbaoJna470yCPMNBGw6XK+A0Y+MgHmdf9JuZRaQacFZ82s2Dlg6sII3RRM1RVg9SJ
2uwEY5wjuqDedXdI06L3QXz9CKVmG7i/qxpsnu3EgPeLyASLWpsIhvt5uNmooz51XEtUAEur
U2YDikgcXXUAlekOIk8Nhu/S+F5a5nna2WKzXN3Z3Ckr60835ci8TooZEqPP6up8x8s0L69U
Ukl+SVhGxmzvOURdJxw0SUJVrbL84lLzuMyFbTSA3bzM0BP7VIlTgU66L2mwCVwvEvTet3x6
ffr+8B1RM2x6L/q4gE391M4V41rTm1ZvOkQy+X7YcE21VuEuND29TSM6ZNwwjQx3O1WdPj++
vz29PD1+vL+9osWQdMJ5h5Ppg5539xBAeev0nAEp0Dq0ogVgvywbo+J+PldKe3l5+fv59fXp
3a1yK9sychS5bgG0ET9zpwOMy5nJaXVRmYg7/mUCLJbH+miMmjLzPd9EIdz6lQE8nZ7t9jY3
lHXXv215ouVovEOPfNFWU+BpBD2xwGMm9GwRR0p9gFhWEYtND6bRJHyOqCVExqqFuZ9YEyWU
RjtKaIfB8jUoyU7tqgOyu7+fP776a9ppuy6MufJ8Onk4IPNgn5c5XL/Btoa3/GzdtPf96mf7
hF0Bp0wUR2Er1zoCGwBHyTfwJCbfojh8RVOFE8nAXMh85wpdkGePFtKh6mRi2C5MZKn7oF/Y
XYH1vjiwGxMbPmdm+HcxTLQy95Tvy2FRSxJVxCnBl7Q9nnbUXZbXaEyiMTsF87UvBIvBtnYt
R0ZsFfyEiPVsRjSmRILAMWTRsfZ4uSUbuQyz9gG9X/ik3y8WS5+pTMewXDp2TB2yIp1t6QwL
qrT3y/lmRYtcLqdzk0RL43VJD+zisHt24gjd1aDBU08ieoY+nKBnEEXVfJm4V/kjRDumNnmm
dFTFQejmCiBrCg3jkoXPOmjgsM0VNcB+C2bCtyUTWzQJrMlGQOhGJSzCFVkHi3BNbgQkcmvM
IVPTbGi5ANDjBcB5MCe2Uwgs6Dqd68EnRvpynpCC1NEctVzjOZyHTqRAr91yO+fpz7xaB/MF
SQ+psqnDPppuG5WOdLpiD3W6mhFpHGMWeY4NOsi5HlfHe1mOO9jZnAoq0nOp3fGGyKp/39wh
RIcczg890HJG1K1EdAe9BrANfch8TXSFHqGrWKFbcsiobPiMlyRHBZvcYNVeoth7HKDzdD7P
XSbQeIOVbbrbA+sN0ZM7gC6VBLfEeOkA32yG8GblDyuq8c1nKyf2FskH5fJFk9XYMPoY0Uck
Ev7bC/gKAr0cRtXUBjuB9Y+ob6DPF1RvlQftZFL1chVMDShkIJOSFzAeOnX2JO9hfFlYUu7G
dAbbQrinbwidQ9HpvlUd6sR0GT0gaJgYUxugHvFIVCEgGfy3D4pAcziWCOqYgjztq6o0tBwC
6tBqdkuF7a5KCMk1m4ekSQIiy6n5osLtLyO3FzWrwuWkIiE5VqRmhdB6RTv0MHjWU7kDDjPY
hw6sbbPzAbCN+TsAlFliaq9hZV4EzlMSCe3ZdrOe6sZ1cp6HMyYiSqfVQLqbDQxzw8msC4cN
lXEdvpXApPhm8us4agJqVqirOQvDNacQpZ15ENvaFYFTzII5pdXgQXJALoaIkJ6aDQaPSOo+
AC3pAmJaRDqlKFGWdwOdGKZIpxQ0pC89+VkS/Qrpa2JQIJ2aO4G+oZQaRfctWNIIcXprNGmn
2DOs6JJtV3ROt2s6p9s13QLbDbEwDXE2nSx/lucl2xXt2VLXs9ZLQsfBsGjUnkzSKQUV6T45
W3QKEXPCvghgK+Bdj+A1+NzjtkvnWS6m5tWMeqk2APaLiREgmkYB5KpWF2wFuzA2VdPqVvBS
ydv8kjxwUyznjuOmrLK5JapuXFGjC0zjLMtIQi35vttnDbaTpkPnyo+uWX3EV1TWXKl8ko00
zRZdPVsRsXsJcBRGyvCz3ckjwau0/s8ONW2fDYwlow6nTkf9hgrljY8S1A3Lt6dH9JmL2XEc
HyE/W9RcN9KQtKg8NXZGJbHd730ZVJ4IiDxK7IRPCZyy8+SetHxAEN1/mpd9iirgFx16T+L5
6cCoE1YEoU+xJHFkFmUei3t+pV29SKnyfYgvo1frDQESob0OeVaKynC11tOgGk12nlYuLeHK
OMDICv8MOfXk5MDTnSjtDrEvHSGHJC9FfqLOehE+izNL9AcNSIRkZQhEi3rltvALS+qcenOj
RPOLfITmZOlaOs5PDQaBwZU8UoXuJQEJv7Gd7tMCSfVFZEeW2YXKKgHDLs/s/CSRfMXjSdB4
Ta4IWX7OHSE57N05acKl+uNBRCm0g5X7FGqwdLOUsus+YZV3imhLrrqYLzmB57D5vrZSy9FE
iV8t6impBdHgWW31i7y0HqjJIcVg1uQldDPa+aXk4TVLrhn9qFAywFBH/xh0aYqEoesX6ErW
0EPvh5Vy5qdnSyNPzWJFKUC38MIVgwalX20rWBoAeLJc8VSoytKJBefoQtCpw6rmjLJd6TCe
VDDRc6vwkHqRnCximVptdsAopqwyH/0NxKnqkdYev+VXTMSTt1qcc2vo5UXF7RFTH2HgOTPT
CRe6tqioXYOcXIRIc3u0NyJLnbH3mZf5RC4/X2PUMKz5oIL5IC/xlstpDYUoX1fdL/9SmBTW
YtKbFhDL8eADmVQZ8DJPLb+dRbnmmFj/wObvXvQp4a8fTy93AmYOOglpwglwa2gTI3nwWRnn
l2x4YThmhRSv7qzT+K7aK6AinIWjk929TJe+PCY+V2rND+UgtfrP94+nv+7Yly/vT18ePt7e
79K333+8PNEFrU7SEtMsZk+838V6of5fKRAJOJEaKX4MQ5wfI9FZJ3UONfWuhxxEVMIBT1Pq
PCoFfaIWuh+ZnjI4OeyCAv719v6f6uP58U8qIGD3ySmr2J7D6lKdUj3IXwWKU7tDLxY6caA4
KRzfvn+gq+TeCX7sTbEW+7TVPRUPyG9yEcva+aYh0HK5DSmyekVtPt9APxbmQ3H8pZ7j6S0w
Ultn9XVZ5LIJy1ZeOjJ2JTqEytDxz/GCvumzg+maS1YYuutymkJ+z3RzUEWB+T+xaEk6X+rX
YSMxdHKEPrQWdLhdiVfzKFw0lAGtKnG+g3ptP510R546UrJPFoARyKmcdHTpe8ufHxs1ylLM
t4uFW0QgkyekHbqc6YdgXUPycw7KlrCrVmbSjLSs029kHrlWc29lKmdreBxcn+w+qdzAOekO
oYZ9MvHKXjeGkMT+0dQinNndZHTrplOzyk0a1ISIWqIlWEcMw0Q7H9VJtNwG/v4Eetd6vTIj
hQ7dd0nFzJNoXquSWMNHWUi9PL/++Uvw6x3Mo3flYXfXecP78YoO/YnV+O6XUTf5VV+qVIWi
nkZ7FFFtnG5mpHWFKl/SRIXuf6ynQkNaRHwj5FQDqLrrzc5bfTUsI+nJsbFW2Bgl3OgLhTNV
MHRs1Tl5V06UXx6+f717gEWsfnt//GpNUEOl1+/PX764k1YNk97BCmGrA8rhmL9Ge7Yc5s1j
TpmVGmxpHXtTOnJQXXec3RRCur01OCLSE73BwiLQg0V9tRuigzsng7T4zmlEa+7kZFU/f/vA
aFrf7z5UfY+dOXv6+OP55QOjU8hoBHe/YLN8PLx/efr4lW4V+D+D/a/hFcIspwzX7c0n7PIE
pX5YTHjA5XTIvppMT1Fm7vTaQ++8VSV2IlGV2p9uPfz54xuW+Psb6GTfvz09PX7VXf57OHqp
HE0f8AGnwEcI5UnzOiEhJxo4Ui0e5V8eHZ7vjW4uQZ8LO5Vw0qa2NL5e6kYrkiY24Xa9dKhm
QMOOFpq+xRWVz4OQ9Lom4cb076Q+WS78H4glkfIyoFJe097eVLp4VjmKKevI9PuBhDQKFqtN
sHGRXlHTSMeozqEZSGLvnvEf7x+Ps3+M2fy/yr61uXGbV/ivZPrpnJn2qe923pn9QF1sq9Et
omQ7+0WTZt1dT3eTnVzmtOfXvwBJSbyASs5MZ1MDEO8EARAEkATQNYjhJBdCvG8SEZcfsrh3
0QXA1aXL3qCxQiSEc3fbLxIbbsR11KFtk8RWbEDRouogsoB/0lLoYOWEh2dHvtng6USdHh0F
C4Ll51gPsj1g4uKzcQE7YE7jhQZVCFJ44JYZ8elcD5lqwtsQuFJT3dF4/QbKhLfHqCZxKz0t
bQcHiWN1rS9lDbG5NkUYDQVSCnlf0JFUfBnOqfoSnsJG3PgQM+8ns5WLOQF86YLLcIu3rh6E
TDJOYeZejJmX3EBtKCGwH6nFtN5QgyvgaqaccoPb+Yx6jd4vexBlllZqZQ23mUzmlNN3Pzfh
sl5uiK5yUJGuJ4wqdpuhr6KfPWCxsA3ImFUawVJ31tI/nBHTGGfzyYzYHtVhbuRl1+GmYjVg
NpvJ2DzxZUYMRwS7cNMftGVi8RedV7n+5kiPIuMH+FLE57M5rYRqS202na3HRhdH5Tok9o/E
gMadmebgYfxXVrAx0chSvfT09xo/DrOCk9xmtiE2LMCXU2IJIHxJ7jHkW5ulioAw0n2gWy+I
zkd8tphQvLJTKO1Jr2+m65ptSL632NSjXA8J5kvfp6SvWU/As9WM6kBwuzA02H7WymU4IYYS
J5vgOH0kc6dpPJytPXENe5IyJm8UtdUpwpW71Sq3925TPD3+horD6IpiPLuerYguqEdGBCLZ
uQannnPxtN3WGUiajHy6208APoQmp068kD4IwcbPQOYhwcBEfCliiqrFlII70fT6D+rNckKy
e97kK+pFpIY/ESOWHcihquH/xnk4r7PSLS4t0b+LXF0gcZ1Ie8cgw+0q8sjJCgwaOjZj9cwI
kDrAV/NrWnCp1yvSp6YXKFx5XPV6Tm3BOppOhb9w7+/Az6BkPY8vcC19hcJEGZOyuZn3rYe6
4rfMxJYxNyEX43d5iO4jcc4C9PXYsxwTfMl8okadrQwMaMJUoozuO25i7ag+aFWuGHCvHTbG
HVgM7weY0Czlj8+LtfnwWoQtZ9PpyZMxD9GepR4diVpUaDcjwNc+4YkJwbBMWeQExlPXPgBd
UY5jHfoUUR+d8Fq32maee3xFVrCaHrAOX7bMatXNvLU+Ga5Awq14PErdg2QiAIDWaYTUJgQW
vsk8MZqDr7I8KLdqwEl8Ge5tXIdJT04MQvEC2VdUj80aMoYFPrU2Y7hJc323GPqCBJOZTVpW
Bp62SYrpxBn2Osl83whuYfcIQ7vsuWcyABfeWh+IsBB7XG1ttsvoO66Bht4A2F87J/DR3niK
zLgCAmBsjKACIJXuNLu1FlEFPeeMO9Mppj5uA8bptNH4Ql80g2LCqky88HMmMHEWuMEc8J2u
dzelspU9zwy/X/DRrXEN23FNzxBj6GA9yNrAPduKJZFWetBsuwiP2rUrlr5NrJAJRwGnfNpk
ORaDBAgciodYJVekm4lEVhY3Be3SOXMHs49ZaZ88PVyYhmLa4m/Qhfb0dDk9zTHRxrw5+TN1
NrpNtMGoZvpzBQSUSmRKKiP0BqIiTLosUXTRLdMfrSGAx1VY6IYfUQWmdrKFMkTkcX2yKy2r
hswrgrhsu9L9UkUb9Yhxhy2GBSyyrGnruzKeWhg4k2+3kQnUqxdEeSEKIFog0Ma27yCY54aA
ZjIygg2G3XRyqhWIHeWiJNFDKB7zO5YF1E4zPmpDlp7iiJ12yLiqmMe1W38fcDCLTphAUZC9
W3IQZts0PmE2arLYjM6aDhPRBnfCQzdjOdvpz25QcupShGjQoDjtmtjMEJwndVUAAwlTdiDD
3tm+tSr/bykcJQIHnsV5QxEb3dKK8OWDVTQBxrw2tSGFERHe/R9mGdFoBHZJYttBzu2I9gWv
uw4M1Qkoao9cuYQQjZbuFRio5OXpr9er/b8/z8+/Ha6+vp1fXjXXl54TvUfaNWlXxXdGTG04
fePIGEwJ8ZrFe7S8xRLsN/mMHjafZpPFZoQsYyedcuJUmSUYydlNRGPTJZx9hAyXgz+tjSLa
zJZLezQEEGR2B34j/xrLVKHypK2KRuWnNVHdyWS3T8Db+ITP3CjfV4NMlW/lp6gZnNN04oLT
ZjWwBLU0KcE1k1dkWqv3FVTcf8ttTMHblJV1URKIEqOIGZJAj6oD0plpsKKYAPNJVA/k+9rI
DNQhQE33F44+4HXhfHYTCFdfOmWpVQKojJVxjdNXjB8GrKIaJbbQ1rNGFY30Ndw3wUjl1r2S
AIMkWQoXZINPa6g+TfUgvsdpyvLi1E8tUWUBAwka03Stv+pRfm/EiuhQc9jgdW0Ef+sxMl9C
UVbxznLa7WhEYFZX8nPpdsC+dugT04b0GUZQYrW81u+aOqLICK2tgLsyppq4L+oypdOVWaOD
i02JwzZFVfjHaWjxGM7Mh7DHHBRhqjnowQ+8VoQT7qYpXULM+VAyXZWS/iRWIT1sMK1KheL7
U+9KKCMnwhqqzn+dn8+PD+erL+eXy9dHQ/dIQk7uqhRDxm3UNU/38udjpWtbKBXqKHWdpHWh
u9Ej+4cPzRabJYnbJ6ulfi2voXiY2UfmgCLT4ekUyVLGwCA/B+SSuuEyaRYLsl1BNt3od3Ia
KozCeD2hRyHkIjl5WHoaJezMIFHyko4VZZFy9s4I7OIsyX0DyITL/DsjMMtKrl+2IDDl08ls
A+p9mkbJjuyoZQPVMMUpZ5xeIlk5sx1ZRDtDfGxgnutY0BEGYDmhbX09wfo9gusRgoAlNyxt
a3KZID7MZuvptI0OpdlklXjCbjKAW8ws4S9OoNudTFfqfHtT5JS6o41hAqwvdNpC5LnoMPuK
MmV32JyX1Ec5H/uIV/Y3FSy1AJ+hvb+s9wnsylV4oP1dbMJrDz+Zr1b05kTU2otaX2/Cg+X5
Y/Kp2Yy82EDtT5iGTZmxCTzfUTTY5vdGJwCFhnyXlJ1C53zCHAybLLMnQ0Bpu3KPpsxgPfL2
U/8e4uv58fIg4s65NxUgLsd5As3aac6Umgl7wKIln3zFaxPNlpo6YCP1abVx5j2Bjj1NJx4G
YFJtPI4LHVUdNjhCpPGKHKfeZpyg1Bn2ogF9/mfnL5f7+vw3ljEMsc488WWl8ShKR9YzKyCc
gwTuy+882ptFmWQ76R02UtoBQ+B9sLx9sjW8zVyKuN6/QxFE5TsUcLC82+rdPPpQo/ULQwc1
tMVXE9DIMfxITe0f5U4O5niJ2XYXbmkFlSC2J3uElpjKMeo4/8jEr9YrWhaUKCkG+GdU0IQs
GxsVQbMDXfwjbRfEHxwVQfuxCRSkBxkQcrwzMH3vUSRlMmEfIQo+QDRl746dIAv+D8MH9DP2
0VER1KMtXV+PtG99/TGOJSh7juWnKON3KN5dbUDz4a0iqd2tMtbbD+5vQSyZ3ftjY3o4OMiP
7wig/eiOANLDO/sBSeTgeEjQA8PbckSqI+O91gjS/vwZKc4dUC/x9ftUm+mcDmxiUa3WH6P6
cPMEsTtRI8QfXXaS+GPLRdB+UELYTM0wnQ7y45WSTrYmzXK68lcGSHKgfVYVQ2bTxLr3ErSQ
uvppJ8/EkarfybTRaQq8ZhX8G84xiU6ZGtFE+kXs03jV9bqpZ8RZfJjZxVSfGZ0BUiDX/HpG
+ogJ7Iat52xhVoLAtR6dawC6dQswOd09dkmVtCbLZ1MKGpDQkCwhpmjXG7Ldaw8D6fDXY8O2
vqZquqZHiMxHMWCpETKCXGnQKV3BysPmeoK13/giCTbvEVy/S7Ac7SWbOE0H2Go38ThTIwXf
w/r0TgN6p4Tlzrxj7TGgLs4QTaPmHlTDA/gKX4SjC4ZFoFxesM6M82oMW5c0NkoOtMVyyKgy
2Czm4Qr9owYqyli/LA/oCUWZvePTXV7wdj5bjuIXY8il83Hfvp5iNRlvY0e4GG/ncjF7pypW
ZauFpy6HFk4QLoY2JC05igwIzDRV6JRmt1OfEsDO3muCIFvMx0dFzHqyTQ6OCVJC27IKSbMz
2odUYuoQw+tbxigdpTvCOsiVGc8O/fPeb7ByUTbbi0C5a0g5oyeBHmXSNdRslondeCro8Ndk
VhnZhtBwTABgcmi303A6mXBE0h9ighKGCyvUE1gp+BTvEZxie1Q1Xux+RZa6X019CFmiVd1C
1GZXZTQo8TdkBV/Pp059mF9lNidqQ8R8PlYbUmzm9Tske6cMA32Yc7ryKJ6NflgtqCm5xjaN
jhF+6ilY48Q1pp0p9bxLKsvFwaxS++TzXX5L2nL3R14muRlyZIAJR0gSYaZZ0xAqkRGBML3e
9zzO2majvYuXsit/envGq0fbiCyetbeF5rUnIWVV6NEyoLPxocYHvnoYUYAGaURAeRV2Xkb9
sHW5wp2H9ANe3L9IgqG4LmtNB+4L7B+UeItEp/MycL/c1nVWTaaTkUf9yanEI9hPIB6crEYI
8PLL17AqcropN7vTVLnD99xfj/CJ9tYkH6W45eZlmK2pDnaTyKI4D+O2rkP3Y/X4x/+xXAFR
cMK6kX03+vIo+Xo6PdkDgN7sFiiHVV7Fbv14mkGn0YuAlSNToNrR53QeI5Je7GlJ0oD8cVhn
wsk2CakjktUZnK9logkUEmR6FHZ1dQnzjrTHbvcayje+4oq3rUpnwNB13V5XeLzbsL3a5WFm
5tbu4FndeF46KnG2gOGi2HRXQK3PeKx6ojKqWZNz0h9/bOa4WLNqQ8D0zBMKWBqMWVYikq7f
wQlTjy4KXns8rVgdwjxOqU3T30V55qXDQ/WF7ofewQ2gCBAlUz8m9WohA7kZ9gaLZ/cfsiQN
CsPHF/ucAYyesz43pEWh8GVoOPF3j4VoYvHGgZUhxmQJLfbellHob4ZKdQe1Uder+OYii27F
5wZTBBkm4zsTKpL3GSDRrET2pBsT4ajNzJdQEkgEKpNhEc4/nl7PP5+fHsiHwDFG9MP7f9JG
RHwsC/354+Ur8c6shG4NrRU/W9MJQ8JE13YY0AcB1GEiyHpf5KFBRsXaRGDW2iMwVqf/oB9c
/ZcKJFc8XoXfLj//GyORPFz+ujxoYdCMM67M2gjkmSTnTnmdkQwz9RED2uXgzQ+MUh8UWty9
Mt6YzphaDt4wybdUuC1JkvUk+thQLVMZnoXPjtni/thDHLINZC6GXU9D8bwgo8oqknLGfF8T
XdFS/TrtGhjW9VTmwIn000cB+bbqJMHg+en+y8PTD7p3SAybeGU8hhXAPjJG3xqyJFFHfip/
3z6fzy8P99/PV7dPz8mtM/2qkPdIZRyh/2Qnf3uFu4TeMIdc+lGAMPfPP3QxStC7zXYmq5fg
vIzJ6SBKFDXFjxj16Cq9vJ5lO4K3y3eMetTvIjdmXlLHerwr/Ck6B4C6KtJUP7kVtgmqeCec
1T8thkZ9vHIV8nAwnxNRFRVHNoWLKD6wMjRhsGYrFm53JrTEUEXHStdzEMxD++5+gHpYiUFJ
XEZ07wao7oiO3r7df4fFaq/7vlx5puEjBlqZkxwYTvBWD4AsoTxILFCamuepAAKPpgIydrgy
cr7gWUwxe4WL8Cvnm2OYcyH4pOQIkeOgb6fh8mE4g0BOQgMpJezdcS2ZrwH024U1/ML3HZlv
oMev9SQIw1cTT2meBAcDAX2JohGs3umHkZZCA089LSKTGAzoja8ndH6bAc+cdmRFYL9m7MkX
7xRnZGkaoDMSOiehoacni5jMdjrg9fsgDaxfCPVC7a4yXmAO+dRJXqItdsLw3pmG4fuE8ttV
+KFo4uM+2CXw76ZMPZqpSGqhnjsfirRmu/hj9PNRep1a40uN0MN7EUHwvtPl++XRPhN7VkFh
+1B1H5ISe+1CPNnZVnHv1ah+Xu2egPDxST90FKrdFYcuC0aRR3HGck200YnwET+mq81DY5kb
JPhog7MD9S5Jp8NQlrxkYeypiXEuTfZGJwihmFVZtxiChneFUBIhEKLmplFpAhwgpWlnQPVV
DIOKSX9z6mFCfKpD4REq5ZJ/Xh+eHlUcCjegsSRut5xdL3SvewW3g0AqsIqCkNfzxfWKXLYG
Ybiv4YTyNhVfMEwXy/XaqR4Q87n+tm2Ar9er6znRtLLOl1MyXZkikOcoCCniqZ5TdFVvrtdz
5sB5tlzqcX4UGB/Dq0FyEKH7MExH1vDvXI8FBOd+ob/xUeJ3G5VbY40H9bRNZ3Dap+TQ41v8
LNkSIyAyM0fbVOCHetDohMEJ8rhuQwuebC2Zj+uR+iO2wWgOUQVt0Ti0MhVVpZluXJgBtlk4
a2NddupsYllIMFVeFbSlLCEDLee1ERYffrYZpy6PEMMyjbcgINEj8wkALl+7QBmppY7paIxI
USb5rizIJAuIrosiNetBZmZXIyKfeqOqH7IYuQeJs4yLUhGqbq8egF8b7247hpO224S0zWAc
fdZaL/i76YXBCRFXJrTLe09X3XoCV3br5DOb+ql4OttgUGJRH73gObCuSWtFE3Btd2Fj01gN
2W9krwx1sLrV07lH5Nt15OVAiDkvNJVNQPPaSMykljWWCnwoSHIrinIBywaNFxilpSQnxSDJ
uLaRgFn0c9Vpq/a0ax2DE+/GXkP9gOCri5BQQyWG1XvThVSBT3xKh9oUaGFjWCzd74K4Ssks
SwrtBOjUwfgrZKmNxUd1bk0wJWSQPoHEdC3JrftRWobTDR0kS+C70GQuUDqWwYkeuKXiPYy3
yP7iwi6211jdAgWqjOjQLUigvRWyi1WPAU2YEMPcegQfz8rpknahVETS4WCMAq/vvW3t3264
9ePVq/8+t3swNLeS31lo+9mQDKm4v7vib3++CAl3kJFUiJEW0MMYaUDhcA2ntI5GsLJha8iB
RQNamdxQGKAsBP2tqHBQcgqXXUCkDceeU3DcK8hziKJ4ItNoY1V2M8sTa2ebPIMdRfIjg0YV
YKGcxmRZOVdQoy4BH6mnYsIa7pQ3+HihTGXhOr0wEr9OEw9aRVQy2qO4tZjCA/B+SuQQM61E
GLf7nbMWgall3MbpHNBQg7tABoqFoqCPe0Ga7BeTNVbja6KQvvBZ/f4uNFsilI3p9aItZ43d
Binh+Ytl2Wq5wOg8kR40BL0cuuPDXLqwr8ukjK05kmrCTRxnAYNRz7JwDO9Mvwojtcu6T40u
KF8O12OjPyXNfd+XjOpjqJsxZT0VK6W8TCE0WAQ6bJL/EYd6XKraNN5lYeByofMz+hXf44Px
H0+PF8zo4yQKQiUxzAzuiKAoC1fAFcqsoTs6UnTPf3Uf5ArdG2NjSBXIG1sFZkcPpQS/uhgS
7bEy0uBJXMaMOOHs8cvz0+WLIZ/mUVX48i8p8kEj0YStLvL5IFcjQIaioIV3gRdyW0KrHQNF
ERY1ZTOWFEpmaGO8NsysJvXYQncalSh0hhBFm2pXvJU5+Eyz7+22tPQjs6Oo5fKI6cGTO3bX
FWjDiSbhSWQ1SZUveArGRtFq6IVlqwb5yWG7AnZnd7C7r3N6qerJD5gJZ1eSJi8RH9euTdwU
e4qraAO76iy6HOaHivUh8/fHq9fn+4fL41ciX1dtrC/4KeO0YIS9xKPP9DR48UFrd0gTNVlG
xYBCHC+aKkQ7YM4Ly8w7YMeyiWhkW1A0Q4eX1XsXYsYo66Eq5qgN3okiDM8dAec1Je30aDhI
yc/KmhIWe3QXU29IZubOmm4G0awcaBTJdpXmWzu441g4dMmkzHnScaKsQKmyToa+BEUTHkqy
AjydWlti1omCKol2WsGqvG0Vx59jB6vOvBIztShrsdWmPpKNDpRB78zWob1om1E21B7Nto1b
UJsnRZfLCVTNNjeTgfRkxqIyxiMrW3tCQMGm7BSY0gz6eIr7G+/s7fvr5ef38z/nZ9IBoTm1
LNqtr2dkHNDmZBn1ENK7NXbXjkQVvewAHLMsDaaIu/2Q8KIywt/wxPTnwd/CLOxN1cXTJKO1
dhzrCv4/N0QOHYoHlx9jRTRw0f6QuSadzw6j0Ynjq+BwFNLp4Q1if85SWNtI6DS7asq6DUnz
uDy0lBdcXlvMU3gC9kjic7Su3sbGJs4KXpPCiWV0l8mqLpjjR0ia+vVHCNp+3B6LKlJ5hIZp
OoDSE7EaODWHjVRxYytzdGxiRnPiUz1rt9QCAcy81aNwKQCIujyBDRGmLorHYVMZWaIAs2it
REIIajBrdFGJ+unKF/66FiN1WfFS/wgiQ0nF315pFErNAjG4piEhgWEEnEcO/MNBdXxVIPSi
EKK8ytrDgiwNSW6boqatISd9TDxVVrVdZZGLcI0iI5TnI2vYEMQ4dLtut6zWDWYgms+sXgX1
yOjkSSq/oMZ75oyQAGHWwNEv2hOr68r57p3B6WjclSMwMO3hjbHi5QcinKPUzaxwbl2BwJ5E
zvSEfEn0uchjt5+YBpGyEvoWPa4Zex9JmMxQCkcIPQEYmq1FCl/cxC1G5Qyru9LOVz7gD7Ea
L/0jCRzbTIoiaBI4cnM4rnY5q5vKiow/EgcvkThx6Uq3nY187WwjHS4voQa1samLLV/4VrFE
e9ak4GX6W1xDuVCBU825K2BoUnZnFSiFjvuHb3oOgDyuB66hM/OOUZkAeycLIK4BTsFcUVhV
L5sS/Qb62u/RIRIn0XAQDRPEi2u0IJID00Tbrttd4XSB8qq84L8Dr/k9PuG/cJyaVfYTXhtj
nXH4zhrcw9bLPgDRBWjFaCAlAzl4MV8P28wuX0K6b5ICw2JiiOFf3l7/2vzSz1HdbXAdMIyt
Dq2O9PE/1n1p6nk5v315uvqLngl0OPatXoEDhT2Nqpja4Tdxleutd3L/7ZtdXKcBOaasCvft
noEQmuzwTiRsxagOi038GRhgZ11ye6MJSRgXVyxQEa+cqjbXs1nAj26OPv1yeXnabJbXv01/
0dHddLcw3cac6Lj1nLrwMUn0QKEGZrOceDEzL8Zfmr+ZG0+EMouIcp+ySLzt0rOnWZjFSLso
HziLZOUt+NqDuZ6vvFVek94b1ue+Xl4vfFVu9JR8iAFGh4uq3Xg+mM68sw+oqd1+xsOEjsGn
V+abwA4/o9s4t2vrEFScAR2/pMtb0eA1Db721T6lAkEYBJ4xny7tIm+KZNNS9r0e2ZhFiZDz
oPvkLjiMMcW5XYPEgHbYVKTrSEdSFay2ctz3uLsqSVPyeqoj2bE4peveVXFMvSDr8Ak0W7q7
OZ8meZNQyqgxDp42g3R2k5BJ4ZGiqbfa+m/yBNe4A2hzdLVLk88MBco+VYVmSijao+F4YKi5
8onJ+eHt+fL6r5t94ybWoxHhL1DQbjEmf2sJRGVc8QSOj7xGsgrEX/1clxJvHLkFttEehOm4
Yk64U0QKeTMJJZKyGCjlAvNWcHELXVeJbmLpCMwTVnCKWiR5gmWfMo8sLuIai8jcOTS9EYku
yrsWQ/yHKpTycGjbZLQEDVIlitjSwEuaQBge6lhIBrO7j9PSeCRIoTFL8v7TL7+//Hl5/P3t
5fz84+nL+bdv5+8/z8/9qdwJVcOI6RluUp59+uX7/eMXfOP2K/7z5el/Hn/99/7HPfy6//Lz
8vjry/1fZ2jp5cuvmKX2Ky6YX//8+dcvcg3dnJ8fz9+vvt0/fzk/oml3WEvqYcOPp+d/ry6P
l9fL/ffL/94jVo+bmaD7Avq95EVuWAQECh02cNg96a0tUjS9apSGaZBuR4f2d6P3tLU3Sy96
4RIvOitn+Pzvz9enq4en5/PV0/OVnA0tiKUghj7tmG6iN8AzFx6ziAS6pPwmTMq9GbzdQLif
gFi5J4EuaWXkIehhJGEvKzoN97aE+Rp/U5Yu9Y1uzu1KQCuBS+pkHjHh3g/aKOGCXVhpgBTV
bjudbYw8ywqRNykNdGsqxV8HLP4Qk97Ue+CqDtzk/d2UJ1nvYl6+/fn98vDb3+d/rx7EEv36
fP/z27/OyqyM/BQSFrnLIzbf1fTQiDrVBixReBxWFJhn7lABBzvEs6UZCdlGYYaKrtPs7fXb
+fH18nD/ev5yFT+KnsPmvfqfy+u3K/by8vRwEajo/vXeGYowzNwZJ2CgrcJ/s0lZpHfTuZ5e
ud+puwTTuxIj1qHgfzi+aeKxJxCTGpX4NqESFPRjuWfACw9d/wPxdBmPhRe3d4G7isJt4MJq
d9uExF6IQ/fbtDo6sIKoo6QacyIqAdnAfMbWba29d/AHlBhdYg40CnY4kcG+1WRhVp26cVcA
WiX7Qd/fv3zzjbmRXq7jtBTwJEfEburBygMnbTqXr+eXV7eyKpzPiDkW4N6PmkDSUJiklGJ1
pxN5fgQpu4ln7lRLOCf6pjC4f/1TAE2pp5NId2K3Mb6G7sh2auvGblC/KjDnDZnXsjssooVT
bhZRRWYJ7NA4xb9j27zKoumKDLmm2MDeiNI3AGGJc92Ta0DNlis/cjmdjX7p+YYCE0VkBKwG
SS0oXGHiWFLliqlrxbRixqJu7UqB6/Lzm/F+puesLvsAmPEWSwNrxboLszhuLX3NR/PuWgkZ
5stJ3AOvQ6gS/Hh5UgCn+jjlzE+KGp0Tr17DemIaagRaU8a6zeuVp4rVh0qIiPkE2LyNQRn2
dG/rka3Uge1F+MoD9auMc0LQknBxwLzz7djEaSRaMY4MkI2MUn0szETJJnyYaxrtaZiJbudH
duelMfond+jTj5/P55cXQ/HrZ3CbMt0DsZMcPhcObLOgTu/088hwAHLvHoGfed3LxRUov08/
rvK3H3+en69258fzs6Widkwi50kblpQGFFXBzkooqGP2VmZWA8fG+YogsqLnuBROvX8kdR1X
MXr7lu5UCW6qonDoSuv3y5/P96AkPz+9vV4eCfklTQKSryK8O76d7J8ujcuA5e3GIRZUcheS
BUjUaB2er60q/JqEidaqchaeQTiyBoGOYl4I70WMSsSPmE7HaMZ6PSLGDIMyqCjjre0Pfbuo
/ZH4kPG7LIvR/iZMd5iNdWiihiybIFU0vAlMstNyct2GcaWsfvHgVTPY7m5CvmnLKjkgHkuR
NJQXPJCu0YWVo73PdtCRWFSYsRS9Crw6x6gwsbzOx4v1zgjpXiCfn1/xjTWojy8iCDWmEbt/
fXs+Xz18Oz/8fXn8qiczxgu2tq4aroyhlZHR0cXzT7/8ojVM4uNTjf6KwzDRltEij1h1R9Rm
lwfbEVMU8t50S96ZfqSnXe1BkmPVMEt5ve24S+plK+gww6q2YvlO3yD4DM4YnyABeRETbmpL
pnvtA6JkHpZ37bYqMmEgpUnSOPdg8Y1tUyf6TWeH2iZ5BP9g3I1ADycXFlVk8gTocRa3eZMF
dFpQaec2XHy610qYDdiMQdmhLDCvs1Kl3NQ2GPI19I0Is/IU7nfCCaWKtxYFXh1vUdhTjpmJ
PhJ9GbBZ4ZzLi7q3yvf7P2zDEA4VAzRdmRSuZgZ9qJvW/MpUMFGz1C4vNI4jMMAx4uBu4zki
NRLaz0uRsOpI7xaJN+e2Ck0JKDR/aRdywCtdJTvULm963Vh7qpFHRab1mWgUyDm9s9NQFkLR
c9iGf0aODYe5KUZ9lqeOBQWpiigZoVTJQngi6Rd0S0CsIsgFmKI/fUaw/VvZ70yYePhTurSJ
FT9ZgRmZhHRA1nvYqMR3HM4K6iZRoYPwD6cFVpL7vpuAJ8GGYKvBlUxqcQD9yqlbQTI6WVpk
5gvXAYrF6lszCPfGD/FIocZzkelJV4WX7gEzAEJh+gmOodCAIYDoxKpKl/yRqSTmUxMJEq6X
ZlhdDLueaWIZPjIqSt27RPRAIoBZ7/TnDgKHCHzEhndhNgNEHIuiqq1B7zC2Mz8mRZ0GZsWh
3ZIyroB3dwhpVTv/df/2/fXq4enx9fL17ent5eqHvEO6fz7fwyH4v+f/pwnI8LHIQp0Fd5hN
eeIgoAq86kavHT1FdYfmaBUS39KMTKcbinqfNiNfcZsk+gMtxLAUBKEMFd2NPkisTFxvKwMB
80dU1k1cEOch6EKVFoaZ71K5xrVlKKJC2heg0m20923UECXMG79pi+1WXCNqeygtAvMXcUse
pp/xQlirvrpFYVo7qLPSzMxdJBGR/VeoFt22PUS8cDfzLq7Rjb3YRox4tYzfCB/4Vj94OT56
1GNT9Kd5iU+jjEvEHtVIf/V2mzZ8b93X90TiSlt/1SkwYgyPTE8MIEBRXBa1BZN6JIhCMFGz
fsFz2H6W+ztwmozRLxWK4A+2I/Mf1yiQmqKBEkgdedK8iO5kbwH9+Xx5fP37CpT8qy8/zi9f
XVeHUL7YwpzXKciYaX9tufZS3DZJXH9a9AtEKRpOCT0FyFVBgcpPXFU5y2K9N94W9raTy/fz
b6+XH0rcfhGkDxL+7PZnC1w9bo+symFSFhtN6IcRLTFcNDaHDjHBInHZCTT69O1jDDqCD4dg
2lPK51ttfum7jX6FGav1Q8fGiOahw7yhfslStoV4Atfk8hPBi9r5jHKpl6tQPcYwnk4dMlAt
mpOJG1xXFRaWKbko9YYcY3aDDBcZDa0efXSGxHwKA9PloVut0fnPt69f0d8geXx5fX77cX58
NV9FsZ2MYUxGSVEN1fhFBxFc9Yj/EiPMxbW2IMjwtc7YIHQloXeGz1VGcI6bXaQxSfVrcOqB
3/ISnfKMRSRWIrdPXZnsQ6BvImoF9NwM1Mj0zvbKHhhiwFkOakCe1HjoMZ29C5x2IITaFwFG
5zXuqnQ45YwtK9on29r9KkoO7eeY9HTrii3shrVxrt83jnVEm4qQM8P55UOrzlxC6K0cE4sH
nYYdY4hyrunLHbiR8LiKT3Wcc2sTyuIQLwQAyoyD3xbH3DDeCItOkfAiNywEQ2mtofxKeFUA
E2CWrN6vDklzPLmtO1JvR3rFvY6aTBNx5W/rsakCquf2bg1w/gFvpGU+xVVTRq18MdtqqkAS
SIFN2b1+D47RzYR0IYPXTleTycRD2ftUbbduH3oqfL/R8tBz1KvuCJ7dcEt47Tg6yCqRoonz
SIp93ik7QPN3wp3P7uIhcyHi8tx+dtYjK2qQtWpAk94R8zc0YYw7KdqkqhvdBDQKlqHnhGsb
sW3kgYQnGMWGNFbADO5mIXBITOlbsT+JdQ3OEnssKrTPwZkwcCJQvmIzBJIoY7xx29iKFSkh
5Dnr8BhnZe2tUGJKjQP6q+Lp58uvV+nTw99vP+XxvL9//Go+7WAiKwCIJQU5pgYeBYsmHrQ8
iRTSfVPr+h0vtjVa5BrkATVs9YIyWKMTqaKSig6WBLsgM85BjYoqSxsORLZ7DH9Tg25EEh1v
QQgDUSwqaKvv+LhJ92GQdr68oYijM/7BYZJA23OG/byJ49KyPUuzMfouDUfVf738vDyiPxM0
6Mfb6/mfM/zP+fXhP//5z39rFmV8pCfK3gn1oX/QpT/TOYw/1VOpfMgoDeo8QTtqHZ9iR/Jy
Mw2p3dyT20fMUeKAzxdHdOj1V3rkceZUKBprbWKERXHpANDQyT9NlzZYeI1xhV3ZWMmNRUgK
RXI9RiKUQkm3cCpKqrBJWQUaVNx0pc3sIVHU3oFgdYHxzHkam4++h69x6tEo0WmP9Pkqhg42
ERoUWtsWO2yUfoIIi+2wz8Ott6iOefJIVnlkSe0+Cfy/LPeuSDniwPa604mEt7kRIFSMkvuN
mEMr8IhQ02BxtU3O4ziCo1narwkZQAoyHvb7t5Q7v9y/3l+hwPmAt0dGqGExc4lpShUHHQXk
O7cB8sUAffkiBC2Qv1EGBPEMIxEkpnf4aDPNysMKBiKvEyYujKQPQdhQsq++HjRLbdigjJT2
8OFuADDvrCEkAfnWLEDDoUwglPT+LJpNrQpwhskljNj4lrtPjQ0K+dCi3YkVBmJIUtBRoMwx
MYcQzh6pXFdCinEnU761BrUBr7vIvQT93Bd1mUqJso670GaaqsRFkqNuUbtve/OilKNRWfJR
b3sYx8IQlHuaJrrLGbIoO5APgWyPSb1HeyL/AFmUVHiyw+SnHyFnlVOqQmciSgdUizeZFgkG
eRQrCClB1cprpxB0LLFtn8AAMIquKtpChqoqGylHDy3QrTVUsp2heZYKk2DQbLf6iIug24Le
0AhxQeAKkrGBnXnSilIWDn7ULyzKKo4z4BPVLT0QTn2dWmhXpAiJt+Vdj/vFD/q/sBB335DP
4D1r07csh51lLBD6lVJXBshI6AFBxvYajno9rm51C5LulqhWanQSTla6P6asHiPAID9Om40x
7JasfQLC/s9BQdoX7orrEL0mZc6+knbgtMOgv2I0LBcKAxc75jFd3BQE6lodxkJ+GZM6RkcM
268jIyodGawgFXlh8PWfb8wakU5SbhttxIJy68C6NWPD6RK6lW46LdzlwIlsUgx9CvTJbgcn
tt5DOfByS8toIEQPhg1J3SnpO5tAdzWwVFxKba2kHGpFSXaFf5rKjjjS0+5CzEWg5szdV9Ya
de6eOkTN4MwvHXFg4GsmDSUWaF32FafT9PGLBLeJ4rRmtIiszR4yOF/9xnS6d4SociURHBH7
MJnOr2WESTRsUPyFYYhjXS4VgJY1pyjhZapfnSmUkj0NriMxlIarKDTbjIwfqQzdce8Z+s9m
RUp1pmztsHVX9nZppLVaeEnd2EF30Xf2EFdBwWNxIDSUIqQX4Ck2CnZmDCqrzvYUBZTVVSnm
aSBuDzUWL+5lLQu7BJpGRnHg90ybUsET9DfBwCyTkyfjvUYRR+MUjfhDPQrtKNTDUlPCLArX
AyIsmd1BSd3JO7bOkSVjfjw4k+oWpdRcg8sGX6uiEmtX1uTHJI8wBXBlOJf1cHm3Jzifzf+V
2G0uWv1itD6/vKJiiUacELO93H896/avm4bekJ1ihXeXRWWEaOo6lNFEBls14zuNbcgb4KqO
yZHDwQfMVi4pM9kl0tPqCoiaQpqC6RHnUpxTWad77zdgAyaDHgD2O2FyMA2tOUs4x0qjImwy
8/CTWnWQyMHiRPHdJfb/B0Aj9UWTPwIA

--WIyZ46R2i8wDzkSu--
